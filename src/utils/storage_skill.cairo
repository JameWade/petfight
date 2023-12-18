use starknet::{
  Store,
  storage_address_from_base_and_offset,
  storage_read_syscall,
  storage_write_syscall,
  SyscallResult,
  StorageBaseAddress,
};
use petfight::structs::skill::Skill;
impl StoreSkillArray of Store<Array<Skill>>{
    fn read(address_domain: u32, base: StorageBaseAddress) -> SyscallResult<Array<Skill>> {
        StoreSkillArray::read_at_offset(address_domain, base, 0)
    }
    fn write(
        address_domain: u32, base: StorageBaseAddress, value: Array<Skill>
    ) -> SyscallResult<()> {
        StoreSkillArray::write_at_offset(address_domain, base, 0, value)
    }
      fn read_at_offset(
        address_domain: u32, base: StorageBaseAddress, mut offset: u8
    ) -> SyscallResult<Array<Skill>> {
        let mut arr: Array<Skill> = ArrayTrait::new();
        // Read the stored array's length. If the length is superior to 255, the read will fail.
        let len: u8 = Store::<u8>::read_at_offset(address_domain, base, offset)
            .expect('Storage Span too large');
        offset += 1;
        // Sequentially read all stored elements and append them to the array.
        let exit = len + offset;
        loop {
            if offset >= exit {
                break;
            }
            let value = Store::<Skill>::read_at_offset(address_domain, base, offset).unwrap();
            arr.append(value);
            offset += Store::<Skill>::size();
        };
        // Return the array.
        Result::Ok(arr)
    }
fn write_at_offset(
        address_domain: u32, base: StorageBaseAddress, mut offset: u8, mut value: Array<Skill>
    ) -> SyscallResult<()> {
        // // Store the length of the array in the first storage slot.
        let len: u8 = value.len().try_into().expect('Storage - Span too large');
        Store::<u8>::write_at_offset(address_domain, base, offset, len);
        offset += 1;

        // Store the array elements sequentially
        loop {
            match value.pop_front() {
                Option::Some(element) => {
                    Store::<Skill>::write_at_offset(address_domain, base, offset, element);
                    offset += Store::<Skill>::size();
                },
                Option::None(_) => {
                    break Result::Ok(());
                }
            };
        }
    }

    fn size() -> u8 {
        255 * Store::<Skill>::size()
    }
}

