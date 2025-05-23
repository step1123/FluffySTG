#define IS_FINITE__UNSAFE(a) (!isinf(a) && !isnan(a))
#define IS_FINITE(a) (isnum(a) && IS_FINITE__UNSAFE(a))

// Credits to Nickr5 for the useful procs I've taken from his library resource.
// This file is quadruple wrapped for your pleasure
// (

#define NUM_E 2.71828183

#define PI 3.1416
#define INFINITY 1e31 //closer then enough

#define SHORT_REAL_LIMIT 16777216

//"fancy" math for calculating time in ms from tick_usage percentage and the length of ticks
//percent_of_tick_used * (ticklag * 100(to convert to ms)) / 100(percent ratio)
//collapsed to percent_of_tick_used * tick_lag
#define TICK_DELTA_TO_MS(percent_of_tick_used) ((percent_of_tick_used) * world.tick_lag)
#define TICK_USAGE_TO_MS(starting_tickusage) (TICK_DELTA_TO_MS(TICK_USAGE_REAL - starting_tickusage))

#define PERCENT(val) (round((val)*100, 0.1))
#define CLAMP01(x) (clamp(x, 0, 1))

//time of day but automatically adjusts to the server going into the next day within the same round.
//for when you need a reliable time number that doesn't depend on byond time.
#define REALTIMEOFDAY (world.timeofday + (MIDNIGHT_ROLLOVER * MIDNIGHT_ROLLOVER_CHECK))
#define MIDNIGHT_ROLLOVER_CHECK ( GLOB.rollovercheck_last_timeofday != world.timeofday ? update_midnight_rollover() : GLOB.midnight_rollovers )

/// Gets the sign of x, returns -1 if negative, 0 if 0, 1 if positive
#define SIGN(x) ( ((x) > 0) - ((x) < 0) )

/// Returns the integer closest to 0 from a division
#define SIGNED_FLOOR_DIVISION(x, y) (SIGN(x) * FLOOR(abs(x) / y, 1))

#define CEILING(x, y) ( -round(-(x) / (y)) * (y) )

#define ROUND_UP(x) ( -round(-(x)))

/// Probabilistic rounding: Adds 1 to the integer part of x with a probability equal to the decimal part of x.
/// ie. ROUND_PROB(40.25) returns 40 with 75% probability, and 41 with 25% probability.
#define ROUND_PROB(x) ( floor(x) + (prob(fract(x) * 100)) )

/// Returns the number of digits in a number. Only works on whole numbers.
/// This is marginally faster than string interpolation -> length
#define DIGITS(x) (ROUND_UP(log(10, x)))

// round() acts like floor(x, 1) by default but can't handle other values
#define FLOOR(x, y) ( round((x) / (y)) * (y) )

// Similar to clamp but the bottom rolls around to the top and vice versa. min is inclusive, max is exclusive
#define WRAP(val, min, max) clamp(( min == max ? min : (val) - (round(((val) - (min))/((max) - (min))) * ((max) - (min))) ),min,max)

/// Increments a value and wraps it if it exceeds some value. Can be used to circularly iterate through a list through `idx = WRAP_UP(idx, length_of_list)`.
#define WRAP_UP(val, max) (((val) % (max)) + 1)

// Real modulus that handles decimals
#define MODULUS(x, y) ( (x) - FLOOR(x, y))

// Cotangent
#define COT(x) (1 / tan(x))

// Secant
#define SEC(x) (1 / cos(x))

// Cosecant
#define CSC(x) (1 / sin(x))

#define ATAN2(x, y) ( !(x) && !(y) ? 0 : (y) >= 0 ? arccos((x) / sqrt((x)*(x) + (y)*(y))) : -arccos((x) / sqrt((x)*(x) + (y)*(y))) )

// Greatest Common Divisor - Euclid's algorithm
/proc/Gcd(a, b)
	return b ? Gcd(b, (a) % (b)) : a

// Least Common Multiple
#define Lcm(a, b) (abs(a) / Gcd(a, b) * abs(b))

#define INVERSE(x) ( 1/(x) )

// Used for calculating the radioactive strength falloff
#define INVERSE_SQUARE(initial_strength,cur_distance,initial_distance) ( (initial_strength)*((initial_distance)**2/(cur_distance)**2) )

#define ISABOUTEQUAL(a, b, deviation) (deviation ? abs((a) - (b)) <= deviation : abs((a) - (b)) <= 0.1)

#define ISEVEN(x) (x % 2 == 0)

#define ISODD(x) (x % 2 != 0)

// Returns true if val is from min to max, inclusive.
#define ISINRANGE(val, min, max) (min <= val && val <= max)

// Same as above, exclusive.
#define ISINRANGE_EX(val, min, max) (min < val && val < max)

#define ISINTEGER(x) (round(x) == x)

#define ISMULTIPLE(x, y) ((x) % (y) == 0)

// Performs a linear interpolation between a and b.
// Note that amount=0 returns a, amount=1 returns b, and
// amount=0.5 returns the mean of a and b.
#define LERP(a, b, amount) ( amount ? ((a) + ((b) - (a)) * (amount)) : a )

/**
 * Performs an inverse linear interpolation between a, b, and a provided value between a and b
 * This returns the amount that you would need to feed into a lerp between A and B to return the third value
 */
#define INVERSE_LERP(a, b, value) ((value - a) / (b - a))

// Returns the nth root of x.
#define ROOT(n, x) ((x) ** (1 / (n)))

// The quadratic formula. Returns a list with the solutions, or an empty list
// if they are imaginary.
/proc/SolveQuadratic(a, b, c)
	ASSERT(a)
	. = list()
	var/d = b*b - 4 * a * c
	var/bottom  = 2 * a
	if(d < 0 || !IS_FINITE__UNSAFE(d) || !IS_FINITE__UNSAFE(bottom))
		return
	var/root = sqrt(d)
	. += (-b + root) / bottom
	if(!d)
		return
	. += (-b - root) / bottom

#define TODEGREES(radians) ((radians) * 57.2957795)

#define TORADIANS(degrees) ((degrees) * 0.0174532925)

/// Gets shift x that would be required the bitflag (1<<x)
/// We need the round because log has floating-point inaccuracy, and if we undershoot at all on list indexing we'll get the wrong index.
#define TOBITSHIFT(bit) ( round(log(2, bit), 1) )

// Will filter out extra rotations and negative rotations
// E.g: 540 becomes 180. -180 becomes 180.
#define SIMPLIFY_DEGREES(degrees) (MODULUS((degrees), 360))

// 180s an angle
#define REVERSE_ANGLE(degrees) (SIMPLIFY_DEGREES(degrees + 180))

#define GET_ANGLE_OF_INCIDENCE(face, input) (MODULUS((face) - (input), 360))

//Finds the shortest angle that angle A has to change to get to angle B. Aka, whether to move clock or counterclockwise.
/proc/closer_angle_difference(a, b)
	if(!isnum(a) || !isnum(b))
		return
	a = SIMPLIFY_DEGREES(a)
	b = SIMPLIFY_DEGREES(b)
	var/inc = b - a
	if(inc < 0)
		inc += 360
	var/dec = a - b
	if(dec < 0)
		dec += 360
	. = inc > dec? -dec : inc

//A logarithm that converts an integer to a number scaled between 0 and 1.
//Currently, this is used for hydroponics-produce sprite transforming, but could be useful for other transform functions.
#define TRANSFORM_USING_VARIABLE(input, max) ( sin((90*(input))/(max))**2 )

//converts a uniform distributed random number into a normal distributed one
//since this method produces two random numbers, one is saved for subsequent calls
//(making the cost negligble for every second call)
//This will return +/- decimals, situated about mean with standard deviation stddev
//68% chance that the number is within 1stddev
//95% chance that the number is within 2stddev
//98% chance that the number is within 3stddev...etc
#define ACCURACY 10000
/proc/gaussian(mean, stddev)
	var/static/gaussian_next
	var/R1;var/R2;var/working
	if(gaussian_next != null)
		R1 = gaussian_next
		gaussian_next = null
	else
		do
			R1 = rand(-ACCURACY,ACCURACY)/ACCURACY
			R2 = rand(-ACCURACY,ACCURACY)/ACCURACY
			working = R1*R1 + R2*R2
		while(working >= 1 || working == 0)
		working = sqrt(-2 * log(working) / working)
		R1 *= working
		gaussian_next = R2 * working
	return (mean + stddev * R1)
#undef ACCURACY

/proc/get_turf_in_angle(angle, turf/starting, increments)
	var/pixel_x = 0
	var/pixel_y = 0
	for(var/i in 1 to increments)
		pixel_x += sin(angle)+(ICON_SIZE_X/2)*sin(angle)*2
		pixel_y += cos(angle)+(ICON_SIZE_Y/2)*cos(angle)*2
	var/new_x = starting.x
	var/new_y = starting.y
	while(pixel_x > (ICON_SIZE_X/2))
		pixel_x -= ICON_SIZE_X
		new_x++
	while(pixel_x < -(ICON_SIZE_X/2))
		pixel_x += ICON_SIZE_X
		new_x--
	while(pixel_y > (ICON_SIZE_Y/2))
		pixel_y -= ICON_SIZE_Y
		new_y++
	while(pixel_y < -(ICON_SIZE_Y/2))
		pixel_y += ICON_SIZE_Y
		new_y--
	new_x = clamp(new_x, 1, world.maxx)
	new_y = clamp(new_y, 1, world.maxy)
	return locate(new_x, new_y, starting.z)

// Returns a list where [1] is all x values and [2] is all y values that overlap between the given pair of rectangles
/proc/get_overlap(x1, y1, x2, y2, x3, y3, x4, y4)
	var/list/region_x1 = list()
	var/list/region_y1 = list()
	var/list/region_x2 = list()
	var/list/region_y2 = list()

	// These loops create loops filled with x/y values that the boundaries inhabit
	// ex: list(5, 6, 7, 8, 9)
	for(var/i in min(x1, x2) to max(x1, x2))
		region_x1["[i]"] = TRUE
	for(var/i in min(y1, y2) to max(y1, y2))
		region_y1["[i]"] = TRUE
	for(var/i in min(x3, x4) to max(x3, x4))
		region_x2["[i]"] = TRUE
	for(var/i in min(y3, y4) to max(y3, y4))
		region_y2["[i]"] = TRUE

	return list(region_x1 & region_x2, region_y1 & region_y2)

#define EXP_DISTRIBUTION(desired_mean) ( -(1/(1/desired_mean)) * log(rand(1, 1000) * 0.001) )

#define LORENTZ_DISTRIBUTION(x, s) ( s*tan(TODEGREES(PI*(rand()-0.5))) + x )
#define LORENTZ_CUMULATIVE_DISTRIBUTION(x, y, s) ( (1/PI)*TORADIANS(arctan((x-(y))/s)) + 1/2 )

#define RULE_OF_THREE(a, b, x) ((a*x)/b)

/// Converts a probability/second chance to probability/seconds_per_tick chance
/// For example, if you want an event to happen with a 10% per second chance, but your proc only runs every 5 seconds, do `if(prob(100*SPT_PROB_RATE(0.1, 5)))`
#define SPT_PROB_RATE(prob_per_second, seconds_per_tick) (1 - (1 - (prob_per_second)) ** (seconds_per_tick))

/// Like SPT_PROB_RATE but easier to use, simply put `if(SPT_PROB(10, 5))`
#define SPT_PROB(prob_per_second_percent, seconds_per_tick) (prob(100*SPT_PROB_RATE((prob_per_second_percent)/100, (seconds_per_tick))))
// )

// This value per these many units. Very unnecessary but helpful for readability (For example wanting 30 units of synthflesh to heal 50 damage - VALUE_PER(50, 30))
#define VALUE_PER(value, per) (value / per)

#define GET_TRUE_DIST(a, b) ((a == null || b == null) ? -1 : max(abs(a.x -b.x), abs(a.y-b.y), abs(a.z-b.z)))

/// Returns the distance between a and b fully ignoring multiz (normal get_dist counts a z move as 1 extra distance)
#define GET_CARDINAL_DIST(a, b) ((a == null || b == null) ? -1 : max(abs(a.x -b.x), abs(a.y-b.y)))

//We used to use linear regression to approximate the answer, but Mloc realized this was actually faster.
//And lo and behold, it is, and it's more accurate to boot.
#define CHEAP_HYPOTENUSE(Ax, Ay, Bx, By) (sqrt((Ax - Bx) ** 2 + (Ay - By) ** 2)) //A squared + B squared = C squared

/// The number of cells in a taxicab circle (rasterized diamond) of radius X.
#define DIAMOND_AREA(X) (1 + 2*(X)*((X)+1))

/// Returns a random decimal between x and y.
#define RANDOM_DECIMAL(x, y) LERP((x), (y), rand())

#define SI_COEFFICIENT "coefficient"
#define SI_UNIT "unit"
