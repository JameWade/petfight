#[starknet::interface]
trait IPanda<TCS> {
    fn new(ref self: TCS) -> panda::petPanda;
    fn pet_upgrade(ref self: TCS) -> panda::petPanda;
    fn pet_fight(self: @TCS,pet_one:panda::petPanda)->bool;
}

#[starknet::component]
mod panda {
    use core::traits::Into;
    use petfight::erc::erc721::erc721 as erc721_comp;
    #[storage]
    struct Storage {
        pet: petPanda,
    }
    #[derive(Drop, Copy, Serde, starknet::Store)]
    struct petPanda {
        experience: u64,
        rank: u16,
        life: u16,
        power: u16,
        agility: u16,
        speed: u16,
    }

    #[embeddable_as(panda)]
    impl pandampl<
        TContractState,
        +HasComponent<TContractState>,
        +Drop<TContractState>,
        impl ERC721: erc721_comp::HasComponent<TContractState>
    > of super::IPanda<ComponentState<TContractState>> {
        fn new(ref self: ComponentState<TContractState>) -> petPanda {
            petPanda { experience: 1, rank: 1, life: 1, power: 1, agility: 1, speed: 1 }
        }
        fn pet_upgrade(ref self: ComponentState<TContractState>) -> petPanda {
            self._upgrade()
        }
        fn pet_fight(self: @ComponentState<TContractState>,pet_one:petPanda) ->bool{
            true
        }
    }
    #[generate_trait]
    impl PandaHelperImpl<
        TContractState, +HasComponent<TContractState>
    > of PrivateTrait<TContractState> {
        fn _upgrade(ref self: ComponentState<TContractState>) -> petPanda {
            let old_pet: petPanda = self.pet.read();
            petPanda {
                experience: old_pet.experience + 10,
                rank: old_pet.rank + 1,
                life: old_pet.life + 1,
                power: old_pet.power + 1,
                agility: old_pet.agility + 1,
                speed: old_pet.speed + 1
            }
        }
    }
}
// //经验
// fn set_experience(ref self:TCS,experience:u64);
// fn get_experience(self:@TCS)->u64;
// //等级
// fn set_rank(ref self:TCS,rank:u16);
// fn get_rank(self:@TCS) ->u16;
// //生命值
// fn set_life(ref self:TCS,life:u16);
// fn get_life(self:@TCS) ->u16;
// //力量  增加命中概率
// fn set_power(ref self:TCS,power:u16);
// fn get_power(self:@TCS) ->u16;
// //敏捷   增加闪避概率
// fn set_agility(ref self:TCS,agility:u16);
// fn get_agility(self:@TCS) ->u16;
// //速度
// fn set_speed(ref self:TCS,speed:u16);
// fn get_speed(self:@TCS) ->u16;


