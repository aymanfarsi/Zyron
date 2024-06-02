#[cfg(test)]
mod tests {
    use crate::api::football;

    #[tokio::test]
    async fn fetch_live_score() {
        match football::scrape_live_score().await {
            Ok(stages) => {
                println!("Found {} stages", stages.len());
            }
            Err(e) => {
                panic!("Failed to fetch live scores: {}", e);
            }
        }
    }
}
