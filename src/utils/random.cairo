#[generate_trait]
impl Random of RandomTrait {
    fn random(seed: u64) -> u128 {
        let seed_felt: felt252 = seed.into();
        let mut rolling_seed_arr: Array<felt252> = ArrayTrait::new();
        //todo get some num on blockchain
        rolling_seed_arr.append(seed_felt);
        rolling_seed_arr.append(seed_felt * 7);
        rolling_seed_arr.append(seed_felt * 29);
        let rolling_hash: u256 = poseidon::poseidon_hash_span(rolling_seed_arr.span()).into();
        let x: u128 = (rolling_hash.low);
        x
    }

    
}
