#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;

#using scripts\zm\_zm_playerhealth;
#using scripts\zm\zm_perk_upgrades;

#insert scripts\shared\shared.gsh;
#insert scripts\zm\_zm_perks.gsh;

function main()
{
	callback::on_spawned( &on_player_spawned );
}

function on_player_spawned()
{
	wait(1);
	self notify("playerHealthRegen");
	self thread playerHealthRegen();
	//self thread testeroo();
}

function playerHealthRegen()
{
	self notify("playerHealthRegen");
	self endon ("playerHealthRegen");
	self endon ("death");
	self endon ("disconnect");

	if( !isdefined( self.flag ) )
	{
		self.flag = []; 
		self.flags_lock = []; 
	}
	if( !isdefined(self.flag["player_has_red_flashing_overlay"]) )
	{
		self flag::init("player_has_red_flashing_overlay");
		self flag::init("player_is_invulnerable");
	}
	self flag::clear("player_has_red_flashing_overlay");
	self flag::clear("player_is_invulnerable");		

	self thread zm_playerhealth::healthOverlay();
	oldratio = 1;
	health_add = 0;
	
	regenRate = 0.1; // 0.017;

	veryHurt = false;
	playerJustGotRedFlashing = false;
	
	invulTime = 0;
	hurtTime = 0;
	newHealth = 0;
	lastinvulratio = 1;
	self thread zm_playerhealth::playerHurtcheck();
	if(!isdefined (self.veryhurt))
	{
		self.veryhurt = 0;	
	}
	
	self.boltHit = false;
	
	if( GetDvarString( "scr_playerInvulTimeScale" ) == "" )
	{
		SetDvar( "scr_playerInvulTimeScale", 1.0 );
	}

	//CODER_MOD: King (6/11/08) - Local copy of this dvar. Calling dvar get is expensive
	playerInvulTimeScale = GetDvarFloat( "scr_playerInvulTimeScale" );

	for( ;; )
	{
		WAIT_SERVER_FRAME;
		waittillframeend; // if we're on hard, we need to wait until the bolt damage check before we decide what to do

		if( self.health == self.maxHealth )
		{
			if( self flag::get( "player_has_red_flashing_overlay" ) )
			{
				self clientfield::set_to_player( "sndZombieHealth", 0 ); 
				self flag::clear( "player_has_red_flashing_overlay" );
			}

			lastinvulratio = 1;
			playerJustGotRedFlashing = false;
			veryHurt = false;
			continue;
		}

		if( self.health <= 0 )
		{
			 
			return;
		}

		wasVeryHurt = veryHurt;
		health_ratio = self.health / self.maxHealth;

		if( health_ratio <= level.healthOverlayCutoff )
		{
			veryHurt = true;
			
			if( !wasVeryHurt )
			{
				hurtTime = gettime();
				self startfadingblur( 3.6, 2 );
				//self thread player_health_visionset();

				self clientfield::set_to_player( "sndZombieHealth", 1 ); 
				self flag::set( "player_has_red_flashing_overlay" );
				playerJustGotRedFlashing = true;
			}
		}

		if( self.hurtAgain )
		{
			if(! self zm_perk_upgrades::IsPerkUpgradeActive(PERK_QUICK_REVIVE))
			{
				hurtTime = gettime();
			}
			self.hurtAgain = false;
		}

		if( health_ratio >= oldratio )
		{
			if( gettime() - hurttime < level.playerHealth_RegularRegenDelay )
			{
				continue;
			}

			if( veryHurt )
			{
				self.veryhurt = 1;
				newHealth = health_ratio;
				regenTime = level.longRegenTime;

				if(self HasPerk(PERK_QUICK_REVIVE))
				{
					regenTime /= 2;
				}
				if( gettime() > hurtTime + regenTime )
				{
					newHealth += regenRate;
				}
			}
			else
			{
				newHealth = 1;
				self.veryhurt = 0;
			}
							
			if( newHealth > 1.0 )
			{
				newHealth = 1.0;
			}
			
			if( newHealth <= 0 )
			{
				 // Player is dead
				return;
			}
			
			self setnormalhealth( newHealth );

			oldratio = self.health / self.maxHealth;
			continue;
		}
		// if we're here, we have taken damage: health_ratio < oldratio.

		invulWorthyHealthDrop = lastinvulRatio - health_ratio > level.worthyDamageRatio;

		if( self.health <= 1 )
		{
			 // if player's health is <= 1, code's player_deathInvulnerableTime has kicked in and the player won't lose health for a while.
			 // set the health to 2 so we can at least detect when they're getting hit.
			self setnormalhealth( 2 / self.maxHealth );
			invulWorthyHealthDrop = true;
		}

		oldratio = self.health / self.maxHealth;

		level notify( "hit_again" );

		health_add = 0;
		hurtTime = gettime();
		self startfadingblur( 3, 0.8 );
		//self thread player_health_visionset();
		
		if( !invulWorthyHealthDrop || playerInvulTimeScale <= 0.0 )
		{
			 
			continue;
		}

		if( self flag::get( "player_is_invulnerable" ) )
			continue;
		self flag::set( "player_is_invulnerable" );
		level notify( "player_becoming_invulnerable" ); // because "player_is_invulnerable" notify happens on both set * and * clear

		if( playerJustGotRedFlashing )
		{
			invulTime = level.invulTime_onShield;
			playerJustGotRedFlashing = false;
		}
		else if( veryHurt )
		{
			invulTime = level.invulTime_postShield;
		}
		else
		{
			invulTime = level.invulTime_preShield;
		}

		invulTime *= playerInvulTimeScale;

		 
		lastinvulratio = self.health / self.maxHealth;
		self thread zm_playerhealth::playerInvul( invulTime );
	}
}

function testeroo()
{
	while(true)
	{
		IPrintLn(self.health);
		wait(0.5);
	}
}