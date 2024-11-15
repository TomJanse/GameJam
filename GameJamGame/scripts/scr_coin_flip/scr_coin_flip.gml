/// @description		Returns a True or False boolean each exactly 50% of the time. Help script implementend because the randomize functions are unintuitive.
/// @returns {Bool}		True or False 50% of the time each
function coin_flip(){
	return irandom(1) == 1
}