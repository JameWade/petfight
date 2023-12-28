use super::{weapon::weapon, weapon::WeaponImpl, skill::Skill, skill::SkillImpl};
use petfight::utils::random::{Random};
use super::pet_panda::petPanda;
#[generate_trait]
impl FightImpl of IFight{
        //entroy is attack count 
    fn compute_damage(
        pet: @petPanda, entroy: u64, weapons: Array<weapon>, skills: Array<Skill>
    ) -> u16 {
        //选择使用weapon or skill  also use get_random_start   todo change
        let use_what = FightImpl::get_random_start(entroy); //true use weapon
        if use_what {
            let weapon = FightImpl::get_random_weapon(entroy, weapons);
            weapon.attack_power
        } else {
            let skill = FightImpl::get_random_skill(entroy, skills);
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

    

}