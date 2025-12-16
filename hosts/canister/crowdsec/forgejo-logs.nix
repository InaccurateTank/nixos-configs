{
  onsuccess = "next_stage";
  name = "inaccuratetank/forgejo-logs";
  filter = "evt.Parsed.program contains 'forgejo'";
  description = "Parse Forgejo logs";
  pattern_syntax = {
    FORGEJO_CUSTOMUSER = "(%{EMAILADDRESS}|%{USERNAME})";
    FORGEJO_CUSTOMDATE = "%{DATE_X} %{TIME}";
  };
  nodes = [
    {
      grok = {
        pattern = "^%{FORGEJO_CUSTOMDATE:timestamp}.*?Failed authentication attempt for %{FORGEJO_CUSTOMUSER:username} from %{IP:remote_ip}:%{NUMBER:remote_port}.* user does not exist";
        apply_on = "message";
        statics = [
          {
            meta = "log_type";
            value = "forgejo_failed_auth";
          }
        ];
      };
    }
    {
      grok = {
        pattern = "^%{FORGEJO_CUSTOMDATE:timestamp}.*?Failed authentication attempt for %{FORGEJO_CUSTOMUSER:username} from \\[%{IP:remote_ip}\\].* user does not exist";
        apply_on = "message";
        statics = [
          {
            meta = "log_type";
            value = "forgejo_failed_auth";
          }
        ];
      };
    }
    {
      grok = {
        pattern = "^%{FORGEJO_CUSTOMDATE:timestamp}.*?Failed authentication attempt from %{IP:remote_ip}:%{NUMBER:remote_port}";
        apply_on = "message";
        statics = [
          {
            meta = "log_type";
            value = "forgejo_failed_auth";
          }
        ];
      };
    }
    {
      grok = {
        pattern = "^%{FORGEJO_CUSTOMDATE:timestamp}.*?Failed authentication attempt from \\[%{IP:remote_ip}\\]";
        apply_on = "message";
        statics = [
          {
            meta = "log_type";
            value = "forgejo_failed_auth";
          }
        ];
      };
    }
    {
      grok = {
        pattern = "^%{FORGEJO_CUSTOMDATE:timestamp}.*?Failed authentication attempt for %{FORGEJO_CUSTOMUSER:username} from %{IP:remote_ip}:%{NUMBER:remote_port}.* user's password is invalid";
        apply_on = "message";
        statics = [
          {
            meta = "log_type";
            value = "forgejo_failed_auth";
          }
        ];
      };
    }
    {
      grok = {
        pattern = "^%{FORGEJO_CUSTOMDATE:timestamp}.*?Failed authentication attempt for %{FORGEJO_CUSTOMUSER:username} from %{IP:remote_ip}:%{NUMBER:remote_port}.* (user|Email address) does not exist";
        apply_on = "message";
        statics = [
          {
            meta = "log_type";
            value = "forgejo_failed_auth";
          }
        ];
      };
    }
  ];
  statics = [
    {
      meta = "service";
      value = "forgejo";
    }
    {
      meta = "user";
      expression = "evt.Parsed.username";
    }
    {
      target = "evt.StrTime";
      expression = "evt.Parsed.timestamp";
    }
    {
      meta = "source_ip";
      expression = "evt.Parsed.remote_ip";
    }
  ];
}
