type user = address

type rank = Chad | GigaChad

type info = {
  is_admin: bool;
  is_whitelisted: bool;
  rank: rank;
  is_invited_to_be_admin: bool;
}

type user_mapping = (user, info) map

type message_mapping = (user, string) map

type storage = {
  user_map: user_mapping;
  message_map: message_mapping;
}