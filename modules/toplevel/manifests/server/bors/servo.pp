class toplevel::server::bors::servo inherits toplevel::server {
    include dirs::builds::bors
    include users::builder
    include config::secrets

    bors::instance {
        "servo":
            basedir => "/builds/bors/servo",
            owner => "$users::builder::username",
            group => "$users::builder::group",
            repo_owner => "$config::bors_servo_repo_owner",
            repo => "$config::bors_servo_repo",
            reviewers => $config::bors_servo_reviewers,
            builders => $config::bors_servo_builders,
            buildbot_url => "$config::bors_servo_buildbot_url",
            bors_user => "$config::secrets::bors_servo_gh_user",
            bors_pass => "$config::secrets::bors_servo_gh_pass";
    }
}
