## Matakana Gem
Gem for interacting with and keeping a transient database in application memory.

This uses the beautiful Ruby hash in its raw form to serve as the holder of data.
This gem is basic, not very useful, yet a fun thing to do during quarantine.

# Setup

Install the Matakana gem.

```bash
gem install matakana
```

Using the gem.

```ruby
include 'matakana'
```

# Usage

First, initialize the hash. This method can be called repeatedly, however will not override the stored data unless the application ends.

```ruby
initialize_storage
```

You now have access to the basic methods version 0.0.0 introduces. There are no deletion functions (by design) so be assured of the interations.

It is important to note that keys can only be symbols or strings.

```ruby
save("key", "value")
# This will upsert the unique key to the data store, along with the key. Keys are not unique.

save("key")
# This will not add to the data store.

term = "search_term"
find_by(term)
# This will search the data store for the search_term key and will return the associated values. By default, all values are stored as arrays.

get_keys
# This will sort the data store and return the results. You can pass quickly: true to return the keys without sorting them.
```

# Bulk Insert

There is a bulk insert feature available, which uses five threads (unless specified) to store data that is passed. Version 0.0.0 only accepts an array of Hashes to be transformed to the data store.

Generally speaking, you do not want to go above the number of CPU cores available to you (in relation to thread count).

```ruby
insert_array = [{ key_1: "value_1"}, { key_2: "value_2" }]
# pass the number two to only use two threads.
bulk_save(insert_array, 2)
```



