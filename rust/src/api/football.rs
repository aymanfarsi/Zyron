use chrono::NaiveDateTime;
use reqwest::get;

#[derive(Debug)]
pub struct Game {
    pub game_time: String,
    pub home_team: String,
    pub away_team: String,
    pub home_score: u8,
    pub away_score: u8,
    pub match_clock: String,
}

#[derive(Debug)]
pub struct Stage {
    pub name: String,
    pub event: String,
    pub games: Vec<Game>,
}

// #[flutter_rust_bridge::frb(sync)]
pub async fn scrape_live_score() -> Result<Vec<Stage>, String> {
    let year_month_day = chrono::Utc::now().format("%Y%m%d").to_string();
    let url = format!(
        "https://prod-public-api.livescore.com/v1/api/app/date/soccer/{}/-4?locale=en&MD=1",
        year_month_day
    );
    let response = get(url).await.expect("Failed to fetch live scores");

    if !response.status().is_success() {
        println!(
            "{:?}",
            response.text().await.expect("Failed to fetch live scores")
        );
        return Err("Failed to fetch live scores".to_string());
    }

    let response = response
        .json::<serde_json::Value>()
        .await
        .expect("Failed to parse JSON");

    let stages_value = response["Stages"]
        .as_array()
        .expect("Failed to parse stages");

    let mut stages = vec![];
    for stage in stages_value {
        let name = stage["Snm"].to_string();
        let event = stage["CompN"].to_string();

        let mut games = vec![];
        let games_value = stage["Events"].as_array().expect("Failed to parse events");
        for game in games_value {
            let game_date_time =
                NaiveDateTime::parse_from_str(&game["Esd"].to_string(), "%Y%m%d%H%M%S")
                    .expect("Failed to parse date time");
            let home_team = game["T1"][0]["Nm"].to_string();
            let home_score = game["Tr1"]
                .to_string()
                .trim()
                .replace('"', "")
                .parse::<u8>()
                .unwrap_or(0);
            let away_team = game["T2"][0]["Nm"].to_string();
            let away_score = game["Tr2"]
                .to_string()
                .trim()
                .replace('"', "")
                .parse::<u8>()
                .unwrap_or(0);
            let match_clock = &game["Eps"].to_string();

            games.push(Game {
                game_time: game_date_time.format("%Y-%m-%d %H:%M:%S").to_string(),
                home_team,
                away_team,
                home_score,
                away_score,
                match_clock: match_clock.to_string(),
            });
        }

        stages.push(Stage { name, event, games });
    }

    Ok(stages)
}
