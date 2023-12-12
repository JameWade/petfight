use core::box::BoxTrait;
use core::array::ArrayTrait;
use petfight::utils::list::ListTrait;
use core::option::OptionTrait;
use core::traits::TryInto;
use core::traits::Into;
use super::{weapon::Weapon, weapon::WeaponImpl, skill::Skill, skill::SkillImpl};
// use alexandria_storage::list::List;
use petfight::utils::list::List;
use petfight::utils::random::{Random};
use petfight::utils::storage_weapon::StoreWeaponArray;
use petfight::utils::storage_skill::StoreSkillArray;
#[derive(Clone, Drop, Serde, starknet::Store)]
struct petPanda {
    name: felt252,
    experience: u64,
    rank: u16,
    blood: u16,
    power: u16,
    agility: u16,
    speed: u16, //用于确定攻击顺序，以及每回合攻击次数
    weapons: Array<Weapon>,
    skills: Array<Skill>,
}
#[generate_trait]
impl PetPandaImpl of PetPandaTrait {
    fn new(name: felt252) -> petPanda {
        let mut init_weapon: Array<Weapon> = ArrayTrait::new();
        let weapon1 = WeaponImpl::new('dao', 'dao');
        let weapon2 = WeaponImpl::new('qiang', 'qiang');
        init_weapon.append(weapon1);
        init_weapon.append(weapon2);
        let mut init_skill: Array<Skill> = ArrayTrait::new();
        let skill1 = SkillImpl::new('dao', 'dao');
        let skill2 = SkillImpl::new('qiang', 'qiang');
        init_skill.append(skill1);
        init_skill.append(skill2);
        petPanda {
            name: name,
            experience: 0,
            rank: 1,
            blood: 100,
            power: 1,
            agility: 1,
            speed: 1, //用于确定攻击顺序，以及每回合攻击次数
            weapons: init_weapon,
            skills: init_skill,
        }
    }
    //1、攻击开始方  随机
    //2、攻击  属性+武器+技能   随机
    //3、防御  属性+武器+技能   随机
    //4、计算伤害
    //loop
    //血量为0   over
    fn fight(self: @petPanda, pet: @petPanda) -> bool {
        let self_blood = *self.blood;
        let mate_blood = *pet.blood;
        let count = 0;
        let result = loop {
            if self_blood <= 0 {
                false;
            } else if mate_blood <= 0 {
                true;
            }
            let start = PetPandaImpl::get_random_start(count);
            if start { //攻击
            } else { //防守
            }
        };
        result
    }
    //entroy is attack count 
    fn attack(entroy: u64, pet: petPanda,weapons: Array<Weapon>,skills:Array<Skill>) -> u64 {
        //选择使用weapon or skill  also use get_random_start   todo change
        let use_what = PetPandaImpl::get_random_start(entroy); //true use weapon
        if use_what {
            let weapon = PetPandaImpl::get_random_weapon(entroy, weapons);
            weapon.attack_power
        } else {
            let skill = PetPandaImpl::get_random_skill(entroy, skills);
            skill.attack_power
        }
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
    fn get_random_weapon(entroy: u64, weapons: Array<Weapon>) -> Weapon {
        let rand: u128 = Random::random(entroy);
        let weapon_num: u32 = weapons.len(); //暂定最多设计20个武器
        let choose: u32 = (rand % weapon_num.into()).try_into().unwrap();
        *weapons.get(choose).unwrap().unbox()
    }

    #[inline(always)]
    fn get_random_skill(entroy: u64, skills:Array<Skill>) -> Skill {
        let rand: u128 = Random::random(entroy);
        let skill_num: u32 = skills.len(); //暂定最多设计20个技能
        let choose: u32 = (rand % skill_num.into()).try_into().unwrap();
        *skills.get(choose).unwrap().unbox()
    }
}
