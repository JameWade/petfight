use array::ArrayTrait;
use starknet::ContractAddress;
#[derive(Component,Copy,Drop,Serde)]
struct PetDuck{
    power:u8,
    blood: u8,
    address: ContractAddress,
}
trait PetDuckTrait {
    fn fight(pet1 :PetDuck,pet2:PetDuck) -> PetDuck;
}

impl PetDuckImpl<T> of PetDuckTrait{
    fn fight(mut pet1 :PetDuck,mut pet2:PetDuck) -> PetDuck{
        if(pet1.blood>0){
            pet2.blood -=10;
        }
        pet2
    }
}