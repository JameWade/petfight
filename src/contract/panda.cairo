#[starknet::interface]
trait IPanda<TCS>{
    //经验
    fn set_experience(self:TCS,experience:u64);
    fn get_experience(self:@TCS)->u64;
    //等级
    fn set_rank(self:TCS,rank:u16);
    fn get_rank(self:@TCS) ->u16;
    //生命值
    fn set_life(self:TCS,life:u16);
    fn get_life(self:@TCS) ->u16;
    //力量  增加命中概率
    fn set_power(self:TCS,power:u16);
    fn get_power(self:@TCS) ->u16;
    //敏捷   增加闪避概率
    fn set_agility(self:TCS,agility:u16);
    fn get_agility(self:@TCS) ->u16;
    //速度
    fn set_speed(self:TCS,speed:u16);
    fn get_speed(self:@TCS) ->u16;
}

#[starknet::component]
mod panda{

    #[storage]
    struct Storage{
        experience:u64,
        rank:u16,
        life:u16,
        power:u16,
        agility:u16,
        speed:u16,
    }

    #[embeddable_as(panda)]
    impl pandampl<
    TContractState,
    +HasComponent,
    +Drop<TContractState>,
    impl ERC721:erc721_comp::HasComponent<TContractState>
    > of super::IPanda<ComponentState<TContractState>>{
        fn get_experience(self:@TContractState)  ->u64{
            self.experience.read(experience)
        }
        fn set_experience(self:TContractState,experience:u64){
            self.experience.write(experience);
        }
    }
}