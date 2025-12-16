[
  {
    name = "inaccuratetank/forgejo-bf";
    description = "Detect Forgejo bruteforce";
    filter = "evt.Meta.log_type == 'forgejo_failed_auth'";
    type = "leaky";
    groupby = "evt.Meta.source_ip";
    leakspeed = "20s";
    capacity = 5;
    blackhole = "1m";
    labels = {
      service = "forgejo";
      behavior = "vcs:bruteforce";
      classification = ["attack.T1110"];
      spoofable = 0;
      confidence = 3;
      label = "Forgejo Bruteforce";
      remediation = true;
    };
  }
  {
    name = "inaccuratetank/forgejo-slow-bf";
    description = "Detect slow Forgejo bruteforce";
    filter = "evt.Meta.log_type == 'forgejo_failed_auth'";
    type = "leaky";
    groupby = "evt.Meta.source_ip";
    leakspeed = "60s";
    capacity = 10;
    blackhole = "1m";
    labels = {
      service = "forgejo";
      behavior = "vcs:bruteforce";
      classification = ["attack.T1110"];
      spoofable = 0;
      confidence = 3;
      label = "Forgejo Slow Bruteforce";
      remediation = true;
    };
  }
  {
    type = "leaky";
    name = "inaccuratetank/forgejo-bf_user-enum";
    description = "Detect Forgejo user enum bruteforce";
    filter = "evt.Meta.log_type == 'forgejo_failed_auth'";
    groupby = "evt.Meta.source_ip";
    distinct = "evt.Meta.user";
    leakspeed = "10s";
    capacity = 5;
    blackhole = "1m";
    labels = {
      service = "forgejo";
      behavior = "vcs:bruteforce";
      spoofable = 0;
      confidence = 3;
      classification = ["attack.T1589" "attack.T1110"];
      label = "Forgejo User Enumeration";
      remediation = true;
    };
  }
]
