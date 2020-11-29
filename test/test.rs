const EYES: &str = ":";

pub fn smile() -> String { format!("{}{}", EYES, ")") }

pub fn frown() -> String { format!("{}{}", EYES, "(") }

pub fn angry() -> String { format!("{}{}{}", ">", EYES, "(") }

/// Provides a string representation of a face
///
/// # Examples
///
/// ```
/// # use examplerust::*;
/// assert_eq!(which(&frown()), "Frown");
/// ```
pub fn which(face: &str) -> &'static str { if face == smile() { "Smile" } else if face == frown() { "Frown" } else if face == angry() { "Angry" } else { "I don't know" } }
/// This function is not called during tests, so it will be considered dead code.
/// By default, and because of dead-code elimination it won't be reported as uncovered
/// since the function will be removed from executable.
/// This is accounted for in the Travis configuration by passing the compiler flag
/// `-C link-dead-code` when building the tests. This flag disables dead code
/// elimination and allows this function to be reported correctly.
pub fn not_called() { println!("This is dead code"); unreachable!(); }

#[cfg(test)]
mod tests { use super::*; #[test] fn can_smile() { assert_eq!(smile(), ":)"); } #[test] fn can_frown() { assert_eq!(frown(), ":("); } #[test] fn can_angry() { assert_eq!(angry(), ">:("); } #[test] fn string_representation() { assert_eq!(which(&smile()), "Smile"); } }
