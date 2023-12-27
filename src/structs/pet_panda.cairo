use core::debug::PrintTrait;
use core::clone::Clone;
use core::box::BoxTrait;
use core::array::ArrayTrait;
use petfight::utils::list::ListTrait;
use core::option::OptionTrait;
use core::traits::TryInto;
use core::traits::Into;
use super::{weapon::weapon, weapon::WeaponImpl, skill::Skill, skill::SkillImpl};
// use alexandria_storage::list::List;
use petfight::utils::list::List;
use petfight::utils::random::{Random};
use petfight::utils::storage_skill::StoreSkillArray;
#[derive(Copy, Drop, Serde, starknet::Store)]
struct petPanda {
    name: felt252,
    experience: u64,
    rank: u16,
    blood: u16,
    power: u16,
    agility: u16,
    speed: u16, //用于确定攻击顺序，以及每回合攻击次数
}
#[generate_trait]
impl PetPandaImpl of PetPandaTrait {
    fn new(name: felt252) -> petPanda {
        let mut init_weapon: Array<weapon> = ArrayTrait::new();
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
        }
    }
    //1、攻击开始方  随机
    //2、攻击  属性+武器+技能   随机
    //3、防御  属性+武器+技能   随机
    //4、计算伤害
    //loop
    //血量为0   over
    fn fight(self: @petPanda, pet: @petPanda) -> bool {
        let mut self_blood = *self.blood;
        let mut mate_blood = *pet.blood;
        let count = 0;
        let mut damage = 0;
        let result = loop {
            //每次循环需要计算轮到谁进行攻击
            let start = PetPandaImpl::get_random_start(count);
            if start { //自己攻击
                damage = 12;
                if self_blood > damage {
                    self_blood -= damage;
                } else {
                    break false;
                }
            } else {
                //对手攻击
                damage = 10;
                if mate_blood > damage {
                    mate_blood -= damage;
                } else {
                    break true;
                }
            }
        };
        result
    }
    //entroy is attack count 
    fn compute_damage(
        pet: @petPanda, entroy: u64, weapons: Array<weapon>, skills: Array<Skill>
    ) -> u64 {
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
    fn get_random_weapon(entroy: u64, weapons: Array<weapon>) -> weapon {
        let rand: u128 = Random::random(entroy);
        let weapon_num: u32 = weapons.len(); //暂定最多设计20个武器
        let choose: u32 = (rand % weapon_num.into()).try_into().unwrap();
        *weapons.get(choose).unwrap().unbox()
    }

    #[inline(always)]
    fn get_random_skill(entroy: u64, skills: Array<Skill>) -> Skill {
        let rand: u128 = Random::random(entroy);
        let skill_num: u32 = skills.len(); //暂定最多设计20个技能
        let choose: u32 = (rand % skill_num.into()).try_into().unwrap();
        *skills.get(choose).unwrap().unbox()
    }


    #[inline(always)]
    fn increase_rank(
        ref self: petPanda,
        experience: u64,
        rank: u16,
        blood: u16,
        power: u16,
        agility: u16,
        speed: u16
    ) -> petPanda {
        self.experience += experience;
        self.rank += rank;
        self.blood += blood;
        self.power += power;
        self.agility += agility;
        self.speed += speed;
        self
    }
}
impl PetPandaPrint of PrintTrait<petPanda> {
    fn print(self: petPanda) {
        self.agility.print();
        self.blood.print();
        self.name.print();
        self.experience.print();
        self.rank.print();
        self.power.print();
        self.speed.print();
    }
}
