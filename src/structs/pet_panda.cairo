use core::traits::PanicDestruct;
use core::traits::Destruct;
use core::option::OptionTrait;
use core::traits::Into;
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
}
// trait PetPandaTrait {
//     fn new() -> petPanda;
//     fn fight(pet1: petPanda, pet2: petPanda) -> petPanda;
//     fn get_blood(pet: petPanda) -> u16;
// }

#[generate_trait]
impl PetPandaImpl of PetPandaTrait {
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



