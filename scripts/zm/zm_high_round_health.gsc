function main()
{
	//thread high_round_health();
	//thread testeroo();
}


function high_round_health() {
	while( true ) {
		level waittill("zombie_total_set");
		if(level.round_number >= 35) {
			level.zombie_health = 11272;
		}
		wait(0.05);
	}
}

function testeroo() {
	while(true) {
		IPrintLn(level.zombie_health);
		wait(2);
	}
}