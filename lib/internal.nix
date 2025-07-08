{lib, inputs, self}: {
  # Simple path fetcher for the externally stored secrets
  fetchSecret = path: "${inputs.secrets}/${path}";

  # Simple fetcher for user public keys for ssh
  fetchPubKeys = keys: lib.map (k: "${self}/users/keys/${k}.pub") keys;
}
