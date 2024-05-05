use std::path::PathBuf;

use winrt_toast::{content::text::TextPlacement, register, Text, Toast, ToastManager};

#[flutter_rust_bridge::frb(sync)]
pub fn greet(name: String) -> String {
    format!("Hello, {name} from Rust!")
}

#[flutter_rust_bridge::frb(sync)]
pub fn show_toast(message: String) {
    let manager = ToastManager::new("AymanFarsi.Zyron");

    let mut toast = Toast::new();
    toast
        .text1("Zyron")
        .text2(Text::new(message))
        .text3(Text::new("evilDAVE").with_placement(TextPlacement::Attribution));

    match manager.show(&toast) {
        Ok(_) => {}
        Err(e) => eprintln!("Error showing toast: {:?}", e),
    }
}

#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
    // Default utilities - feel free to customize
    flutter_rust_bridge::setup_default_user_utils();

    // Initialize the ToastManager
    let icon_path = "assets/zyron_icon.png";
    let obsolute_icon_path = PathBuf::from(icon_path).canonicalize().unwrap();
    match register("AymanFarsi.Zyron", "Zyron", Some(obsolute_icon_path.as_path())) {
        Ok(_) => {}
        Err(e) => eprintln!("Error registering toast: {:?}", e),
    }

    println!("Rust app initialized!");
}
