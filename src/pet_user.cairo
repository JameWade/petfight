use starknet::ContractAddress;
use petfight::pet_duck::PetDuck;
#[derive(Copy, Drop, Serde, starknet::Store)]
struct User{
    pet:PetDuck,
    address:ContractAddress,
}