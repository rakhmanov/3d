# bellows

![preview](bellows.png)

## v2: rounded folds ([bellows-v2.scad](bellows-v2.scad))

Same fit as v1 (diameter, cap hole and funnel insert), but with rounded folds, a 0.7 mm wall
measured straight through (v1 is 0.57 mm on its slopes), and 7 shallower folds instead of 5.
Made to stop the tears at the narrow rings when printed in TPU 95A.

![preview v2](bellows-v2.png)

## v3: v2 plus a hard stop ([bellows-v3.scad](bellows-v3.scad) + [bellows-v3-stop.scad](bellows-v3-stop.scad))

Print the bellows in TPU and the stop tube in PLA or PETG. The tube drops in from the cap end
and rests on a seat inside the funnel insert. When you press, the cap hits the tube after
`stroke` mm (18 by default): the folds never get crushed flat, and the press ends in a rigid
knock into the grinder, which is what frees stuck coffee.

![preview v3](bellows-v3.png)
