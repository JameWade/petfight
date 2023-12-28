use core::{starknet::StorePacking, traits::{TryInto, Into}};
#[derive(Copy, Drop,Serde, starknet::Store)]
struct Skill{
     name:felt252,
     symbol:felt252,
     attack_power:u16,
     rank:u64,
}
#[generate_trait]
impl SkillImpl of SkillTrait {
    fn update() {}
    fn new(name:felt252,symbol:felt252) -> Skill {
        Skill { name: name, symbol: symbol, attack_power: 10, rank: 1, //等级
         }
    }
}

