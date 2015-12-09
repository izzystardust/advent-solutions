use std::io;
use std::io::Read;
use std::collections::HashMap;

fn main() {
    let mut visits = HashMap::new();

    let mut santas = [(0,0), (0,0)];
    let mut santa  = 0;

    let stdin = io::stdin();
    
    {
        let (x,y) = santas[santa];
        let loc = visits.entry( (x,y) ).or_insert(0);
        *loc += 1;
    }

    for raw_c in stdin.lock().bytes() {
        let c = raw_c.unwrap() as char;
        let (mut x, mut y) = santas[santa];
        match c {
            '>' => {x += 1;}
            '<' => {x -= 1;}
            '^' => {y += 1;}
            'v' => {y -= 1;}
            _   => {break;}
        }
        let loc = visits.entry( (x,y) ).or_insert(0);
        *loc += 1;
        santas[santa] = (x,y);
        santa = (santa + 1) % 2;
    }

    println!("Houses visited: {}", visits.len());
}
