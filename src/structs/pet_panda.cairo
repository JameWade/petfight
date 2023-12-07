use core::traits::PanicDestruct;
use core::traits::Destruct;
use core::option::OptionTrait;
use core::traits::Into;
<<<<<<< Updated upstream
use core::traits::TryInto;
use debug::PrintTrait;
use array::ArrayTrait;
use starknet::ContractAddress;
use petfight::utils::storage_felt::StoreFelt252Array;
use starknet::get_caller_address;
#[derive(Component, Drop, Serde, starknet::Store)]
struct petPanda {
    experience: u64,
    rank: u16,
    blood: u16,
    power: u16,
    agility: u16,
    speed: u16,
    weapons: Array<felt252>
=======
use super::{weapon::Weapon, skill::Skill};
use alexandria_storage::list::List;
use petfight::utils::random::{Random};
#[derive(Drop, starknet::Store)]
struct petPanda {
    life: u32,
    name: felt252,
    weapons: List<Weapon>,
    skills: List<Skill>,
>>>>>>> Stashed changes
}
// trait PetPandaTrait {
//     fn new() -> petPanda;
//     fn fight(pet1: petPanda, pet2: petPanda) -> petPanda;
//     fn get_blood(pet: petPanda) -> u16;
// }

#[generate_trait]
impl PetPandaImpl of PetPandaTrait {
<<<<<<< Updated upstream
    fn fight(mut pet1: petPanda, mut pet2: petPanda) -> petPanda {
        if (pet1.blood > 0) {
            pet2.blood -= 10;
        }
    
        pet2
    }

    fn new() -> petPanda {
        let mut arr: Array<felt252> = ArrayTrait::new();
        petPanda { experience: 1, rank: 1, blood: 1, power: 1, agility: 1, speed: 1, weapons: arr }
    }
    fn get_blood(pet: petPanda) -> u16 {
        return pet.blood;
    }
    //@随机数
    fn get_random_weapon(entroy:felt252,pet:petPanda) ->felt252{
        let rd = PetPandaImpl::get_rand(entroy);
        let weapons_num = pet.weapons.len();
        let choose:u32 = (rd % (weapons_num.into())).try_into().unwrap();
        *pet.weapons.at(choose.into())
    }
    //@随机数
    fn get_random_skill(entroy:felt252,pet:petPanda){
        
    }

    fn  get_rand(entroy:felt252)  ->u128{
        123
    }
}



=======
    //1、攻击开始方  随机
    //2、攻击  属性+武器+技能   随机
    //3、防御  属性+武器+技能   随机
    //4、计算伤害
    //loop
    //血量为0   over

    fn fight(self: @petPanda, pet: @petPanda) -> bool {
        let self_life = *self.life;
        let mate_life = *pet.life;
        let count = 0;
        let result = loop {
            if self_life <= 0 {
                false;
            } else if mate_life <= 0 {
                true;
            }
            let start = PetPandaImpl::get_random_start(count);
            if start {//攻击
            } else {//防守
            }
        };
        result
    }
    #[inline(always)]
    fn get_random_start(entroy: u64) -> bool {
        let rand = Random::random(entroy);
        let bit = rand % 2;
        if bit == 1 {
            true
        } else {
            false
        }
    }
    #[inline(always)]
    fn get_random_weapon(entroy: u64, pet: petPanda) -> Weapon {
        let rand: u128 = Random::random(entroy);
        let weapon_num: u16 = pet.weapons.len.try_into().unwrap(); //暂定最多设计20个武器
        let choose: u32 = (rand % weapon_num.into()).try_into().unwrap();
        pet.weapons.get(choose).unwrap()
    }
    #[inline(always)]
    fn get_random_skill(entroy: u64, pet: petPanda) -> Skill {
        let rand: u128 = Random::random(entroy);
        let skill_num: u16 = pet.skills.len.try_into().unwrap(); //暂定最多设计20个武器
        let choose: u32 = (rand % skill_num.into()).try_into().unwrap();
        pet.skills.get(choose).unwrap()
    }
}
>>>>>>> Stashed changes
