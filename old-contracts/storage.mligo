type user = address
type value = string

type tier = Platinum | Gold | Silver | Bronze | Moldu

type mapping = (user, (value * tier)) map
type blacklist = user list

type t = {
    admin: address;
    user_map : mapping;
    user_blacklist : blacklist
}