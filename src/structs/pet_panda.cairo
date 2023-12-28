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
use petfight::structs::fight::FightImpl;
#[derive(Copy, Drop, Serde, starknet::Store)]
struct petPanda {
    name: felt252,
    xp: u64,
    level: u16,
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
            xp: 0,
            level: 1,
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
    fn fight(self: @petPanda, pet: @petPanda,self_weapons: Array<weapon>, self_skills: Array<Skill>,mate_weapons: Array<weapon>, mate_skills: Array<Skill>) -> bool {
        let mut self_blood = *self.blood;
        let mut mate_blood = *pet.blood;
        let count = 0;
        let mut damage:u16 = 0;
        let result = loop {
            //每次循环需要计算轮到谁进行攻击
            let start = FightImpl::get_random_start(count);
            if start { //自己攻击
                damage = FightImpl::compute_damage( pet, count, self_weapons, self_skills);
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




    #[inline(always)]
    fn increase_level(
        ref self: petPanda,
        xp: u64,
        level: u16,
        blood: u16,
        power: u16,
        agility: u16,
        speed: u16
    ) -> petPanda {
        self.xp += xp;
        self.level += level;
        self.blood += blood;
        self.power += power;
        self.agility += agility;
        self.speed += speed;
        self
    }
    // 负责经验数值更新
    #[inline(always)]
    fn increase_xp(self:petPanda){
        if self.level>0 && self.level<=10{

        }else if self.level>10&& self.level<20{

        }
    }
}
impl PetPandaPrint of PrintTrait<petPanda> {
    fn print(self: petPanda) {
        self.agility.print();
        self.blood.print();
        self.name.print();
        self.xp.print();
        self.level.print();
        self.power.print();
        self.speed.print();
    }
}
