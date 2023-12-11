
use array::ArrayTrait;
use starknet::ContractAddress;
use petfight::utils::storage_felt::StoreFelt252Array;
use starknet::get_caller_address;
#[derive(Component, Drop, Serde, starknet::Store)]
struct PetDuck {
    power: u8,
    blood: u8,
    address: ContractAddress,
    weapons: Array<felt252>
}
trait PetDuckTrait {
    fn new() -> PetDuck;
    fn fight(pet1: PetDuck, pet2: PetDuck) -> PetDuck;
    fn get_blood(pet: PetDuck) ->u8;
}

impl PetDuckImpl of PetDuckTrait {
    fn fight(mut pet1: PetDuck, mut pet2: PetDuck) -> PetDuck {
        if (pet1.blood > 0) {
            pet2.blood -= 10;
        }
        pet2
    }

    fn new() -> PetDuck {
        let mut arr: Array<felt252> = ArrayTrait::new();
        let mut pet = PetDuck {
            power: 10, blood: 100, address: get_caller_address(), weapons: arr
        };
        pet
    }
    fn get_blood(pet: PetDuck)  -> u8{
        return pet.blood;
    }
}
