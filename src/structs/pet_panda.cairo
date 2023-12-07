use alexandria_storage::list::ListTrait;
use core::option::OptionTrait;
use core::traits::TryInto;
use core::traits::Into;
use super::{weapon::Weapon,skill::Skill};
use alexandria_storage::list::List;
use petfight::utils::random::{Random};
#[derive(Drop,starknet::Store)]
struct petPanda {
    life:u32,
    name:felt252,
    weapons:List<Weapon>,
    skills:List<Skill>,
}
#[generate_trait]
impl PetPandaImpl of PetPandaTrait {
    //1、攻击开始方  随机
    //2、攻击  属性+武器+技能   随机
    //3、防御  属性+武器+技能   随机
    //4、计算伤害
    //loop
    //血量为0   over
    fn fight(self:@petPanda,pet:@petPanda) -> bool{
        let self_life = *self.life;
        let mate_life = *pet.life;
        let count = 0;
        let result = loop{
            if self_life <= 0 {
                false;
            }else if  mate_life<=0{
                true;
            }
            let start = PetPandaImpl::get_random_start(count);
            if start{
                //攻击
            }else{
                //防守
            }
        };
        result
    }
    fn get_random_start(entroy:u64) ->bool{
        let rand = Random::random(entroy);
        let bit = rand % 2 ;
        if bit == 1{
            true
        }else{
            false
        }
    }
    fn get_random_weapon(entroy:u64,pet:petPanda)->Weapon{
        let rand:u128 = Random::random(entroy);  
        let weapon_num:u16 = pet.weapons.len.try_into().unwrap();  //暂定最多设计20个武器
        let choose:u32 = (rand % weapon_num.into()).try_into().unwrap();
        pet.weapons.get(choose).unwrap() 
    }


    fn get_random_skill(entroy:u64,pet:petPanda)  ->Skill{
        let rand:u128 = Random::random(entroy);  
        let skill_num:u16 = pet.skills.len.try_into().unwrap();  //暂定最多设计20个武器
        let choose:u32 = (rand % skill_num.into()).try_into().unwrap();
        pet.skills.get(choose).unwrap() 
    }
}