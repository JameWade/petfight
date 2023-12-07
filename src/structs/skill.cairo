use core::{starknet::StorePacking, traits::{TryInto, Into}};
#[derive(Copy, Drop, starknet::Store)]
struct Skill{
     name:felt252,
     symbol:felt252,
     attack_power:u64,
}

