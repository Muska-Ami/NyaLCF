class LauncherSetting {
  LauncherSetting({
    required this.theme_auto,
    required this.theme_dark,
    required this.theme_light_seed_enable,
    required this.theme_light_seed,
  });

  final bool theme_auto;
  final bool theme_dark;
  final bool theme_light_seed_enable;
  final String theme_light_seed;

  Map<String, dynamic> toJson() => {
        'theme': {
          'auto': theme_auto,
          'dark': {
            'enable': theme_dark,
          },
          'light': {
            'seed': {
              'enable': theme_light_seed_enable,
              'value': theme_light_seed,
            },
          }
        },
      };

  LauncherSetting.fromJson(Map<String, dynamic> json)
      : theme_auto = json['theme']['auto'],
        theme_dark = json['theme']['dark']['enable'],
        theme_light_seed = json['theme']['light']['seed']['value'],
        theme_light_seed_enable = json['theme']['light']['seed']['enable'];
}
