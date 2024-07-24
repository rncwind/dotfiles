{
  config,
  lib,
  pkgs,
  ...
}: {
  services.fail2ban = {
    enable = true;
    maxretry = 5;
    ignoreIP = [
      # Ignore the tailnet
      "100.80.12.0/24"
    ];

    bantime = "1h";
    bantime-increment = {
      enable = true;
      formula = "ban.Time * math.exp(float(ban.Count+1)*banFactor)/math.exp(1*banFactor)";
      multipliers = "1 2 4 8 16 32 64";
      maxtime = "168h"; # Do not ban for more than 1 week
      overalljails = true; # Calculate the bantime based on all the violations
    };

    jails = {
      postfix-sasl.settings = {
        filter = "postfix-sasl";
        action = "iptables[name=postfix, port=smtp, protocol=tcp]";
        maxretry = 5;
      };
    };
  };
}
