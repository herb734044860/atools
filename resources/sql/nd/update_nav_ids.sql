-- *****************************************************************************
-- Copyright 2015-2016 Alexander Barthel albar965@mailbox.org
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.
-- ****************************************************************************/


create index if not exists idx_waypoint_type on waypoint(type);
create index if not exists idx_waypoint_region on waypoint(region);
create index if not exists idx_waypoint_ident on waypoint(ident);

create index if not exists idx_vor_type on vor(type);
create index if not exists idx_vor_region on vor(region);

create index if not exists idx_ndb_type on ndb(type);
create index if not exists idx_ndb_region on ndb(region);


create index if not exists idx_approach_fix_type on approach(fix_type);
create index if not exists idx_approach_fix_ident on approach(fix_ident);
create index if not exists idx_approach_fix_region on approach(fix_region);
create index if not exists idx_approach_fix_fix_airport_ident on approach(fix_airport_ident);

create index if not exists idx_approach_leg_fix_type on approach_leg(fix_type);
create index if not exists idx_approach_leg_fix_ident on approach_leg(fix_ident);
create index if not exists idx_approach_leg_fix_region on approach_leg(fix_region);
create index if not exists idx_approach_leg_fix_fix_airport_ident on approach_leg(fix_airport_ident);

create index if not exists idx_approach_leg_recommended_fix_type on approach_leg(recommended_fix_type);
create index if not exists idx_approach_leg_recommended_fix_ident on approach_leg(recommended_fix_ident);
create index if not exists idx_approach_leg_recommended_fix_region on approach_leg(recommended_fix_region);

create index if not exists idx_transition_fix_type on transition(fix_type);
create index if not exists idx_transition_fix_ident on transition(fix_ident);
create index if not exists idx_transition_fix_region on transition(fix_region);
create index if not exists idx_transition_fix_fix_airport_ident on transition(fix_airport_ident);

create index if not exists idx_transition_leg_fix_type on transition_leg(fix_type);
create index if not exists idx_transition_leg_fix_ident on transition_leg(fix_ident);
create index if not exists idx_transition_leg_fix_region on transition_leg(fix_region);
create index if not exists idx_transition_leg_fix_fix_airport_ident on transition_leg(fix_airport_ident);

create index if not exists idx_transition_leg_recommended_fix_type on transition_leg(recommended_fix_type);
create index if not exists idx_transition_leg_recommended_fix_ident on transition_leg(recommended_fix_ident);
create index if not exists idx_transition_leg_recommended_fix_region on transition_leg(recommended_fix_region);

----------------------------------------------------------------
-- Update navigation references for waypoint -------------------

update waypoint set nav_id =
(
  select v.vor_id
  from vor v
  where waypoint.type = 'VOR' and
  waypoint.ident = v.ident and
  waypoint.region = v.region
)
where waypoint.type = 'VOR';

update waypoint set nav_id =
(
  select n.ndb_id
  from ndb n
  where waypoint.type = 'NDB' and
  waypoint.ident = n.ident and
  waypoint.region = n.region
)
where waypoint.type = 'NDB';

----------------------------------------------------------------
-- Update navigation references for approach -------------------

update approach set fix_nav_id =
(
  select v.vor_id
  from vor v
  where approach.fix_type = 'VOR' and approach.fix_ident = v.ident and approach.fix_region = v.region
) where approach.fix_type = 'VOR';

update approach set fix_nav_id =
(
  select n.ndb_id
  from ndb n
  where approach.fix_type = 'NDB' and approach.fix_ident = n.ident and approach.fix_region = n.region
) where approach.fix_type = 'NDB';

update approach set fix_nav_id =
(
  select w.waypoint_id
  from waypoint w
  where approach.fix_type = 'WAYPOINT' and approach.fix_ident = w.ident and approach.fix_region = w.region
) where approach.fix_type = 'WAYPOINT';

-- Terminals -----------------------------------
update approach set fix_nav_id =
(
  select n.ndb_id
  from ndb n join airport a on n.airport_id = a.airport_id
  where approach.fix_type = 'TERMINAL_NDB' and approach.fix_ident = n.ident and
  approach.fix_region = n.region and a.ident = approach.fix_airport_ident
) where approach.fix_type = 'TERMINAL_NDB';

update approach set fix_nav_id =
(
  select w.waypoint_id
  from waypoint w join airport a on w.airport_id = a.airport_id
  where approach.fix_type = 'TERMINAL_WAYPOINT' and approach.fix_ident = w.ident and
  approach.fix_region = w.region and a.ident = approach.fix_airport_ident
) where approach.fix_type = 'TERMINAL_WAYPOINT';

----------------------------------------------------------------
-- Update navigation references for transition -------------------

update transition set fix_nav_id =
(
  select v.vor_id
  from vor v
  where transition.fix_type = 'VOR' and transition.fix_ident = v.ident and transition.fix_region = v.region
) where transition.fix_type = 'VOR';

update transition set fix_nav_id =
(
  select n.ndb_id
  from ndb n
  where transition.fix_type = 'NDB' and transition.fix_ident = n.ident and transition.fix_region = n.region
) where transition.fix_type = 'NDB';

update transition set fix_nav_id =
(
  select w.waypoint_id
  from waypoint w
  where transition.fix_type = 'WAYPOINT' and transition.fix_ident = w.ident and transition.fix_region = w.region
) where transition.fix_type = 'WAYPOINT';

-- Terminals -----------------------------------

update transition set fix_nav_id =
(
  select n.ndb_id
  from ndb n join airport a on n.airport_id = a.airport_id
  where transition.fix_type = 'TERMINAL_NDB' and transition.fix_ident = n.ident and
  transition.fix_region = n.region and a.ident = transition.fix_airport_ident
) where transition.fix_type = 'TERMINAL_NDB';

update transition set fix_nav_id =
(
  select w.waypoint_id
  from waypoint w join airport a on w.airport_id = a.airport_id
  where transition.fix_type = 'TERMINAL_WAYPOINT' and transition.fix_ident = w.ident and
  transition.fix_region = w.region and a.ident = transition.fix_airport_ident
) where transition.fix_type = 'TERMINAL_WAYPOINT';

----------------------------------------------------------------
-- Update navigation references for approach legs --------------

update approach_leg set fix_nav_id =
(
  select v.vor_id
  from vor v
  where approach_leg.fix_type = 'VOR' and approach_leg.fix_ident = v.ident and approach_leg.fix_region = v.region
) where approach_leg.fix_type = 'VOR';

update approach_leg set fix_nav_id =
(
  select n.ndb_id
  from ndb n
  where approach_leg.fix_type = 'NDB' and approach_leg.fix_ident = n.ident and approach_leg.fix_region = n.region
) where approach_leg.fix_type = 'NDB';

update approach_leg set fix_nav_id =
(
  select w.waypoint_id
  from waypoint w
  where approach_leg.fix_type = 'WAYPOINT' and approach_leg.fix_ident = w.ident and approach_leg.fix_region = w.region
) where approach_leg.fix_type = 'WAYPOINT';

-- Terminals -----------------------------------
update approach_leg set fix_nav_id =
(
  select n.ndb_id
  from ndb n join airport a on n.airport_id = a.airport_id
  where approach_leg.fix_type = 'TERMINAL_NDB' and approach_leg.fix_ident = n.ident and
  approach_leg.fix_region = n.region and a.ident = approach_leg.fix_airport_ident
) where approach_leg.fix_type = 'TERMINAL_NDB';

update approach_leg set fix_nav_id =
(
  select w.waypoint_id
  from waypoint w join airport a on w.airport_id = a.airport_id
  where approach_leg.fix_type = 'TERMINAL_WAYPOINT' and approach_leg.fix_ident = w.ident and
  approach_leg.fix_region = w.region and a.ident = approach_leg.fix_airport_ident
) where approach_leg.fix_type = 'TERMINAL_WAYPOINT';

----------------------------------------------------------------
-- Update navigation references for transition legs ------------

update transition_leg set fix_nav_id =
(
  select v.vor_id
  from vor v
  where transition_leg.fix_type = 'VOR' and transition_leg.fix_ident = v.ident and transition_leg.fix_region = v.region
) where transition_leg.fix_type = 'VOR';

update transition_leg set fix_nav_id =
(
  select n.ndb_id
  from ndb n
  where transition_leg.fix_type = 'NDB' and transition_leg.fix_ident = n.ident and transition_leg.fix_region = n.region
) where transition_leg.fix_type = 'NDB';

update transition_leg set fix_nav_id =
(
  select w.waypoint_id
  from waypoint w
  where transition_leg.fix_type = 'WAYPOINT' and transition_leg.fix_ident = w.ident and transition_leg.fix_region = w.region
) where transition_leg.fix_type = 'WAYPOINT';

-- Terminals -----------------------------------

update transition_leg set fix_nav_id =
(
  select n.ndb_id
  from ndb n join airport a on n.airport_id = a.airport_id
  where transition_leg.fix_type = 'TERMINAL_NDB' and transition_leg.fix_ident = n.ident and
  transition_leg.fix_region = n.region and a.ident = transition_leg.fix_airport_ident
) where transition_leg.fix_type = 'TERMINAL_NDB';

update transition_leg set fix_nav_id =
(
  select w.waypoint_id
  from waypoint w join airport a on w.airport_id = a.airport_id
  where transition_leg.fix_type = 'TERMINAL_WAYPOINT' and transition_leg.fix_ident = w.ident and
  transition_leg.fix_region = w.region and a.ident = transition_leg.fix_airport_ident
) where transition_leg.fix_type = 'TERMINAL_WAYPOINT';

---------------------------------------------------------------
-- Update navigation references for approach legs --------------

update approach_leg set recommended_fix_nav_id =
(
  select v.vor_id
  from vor v
  where approach_leg.recommended_fix_type = 'VOR' and approach_leg.recommended_fix_ident = v.ident and
  approach_leg.recommended_fix_region = v.region
) where approach_leg.recommended_fix_type = 'VOR';

update approach_leg set recommended_fix_nav_id =
(
  select n.ndb_id
  from ndb n
  where approach_leg.recommended_fix_type = 'NDB' and approach_leg.recommended_fix_ident = n.ident and
  approach_leg.recommended_fix_region = n.region
) where approach_leg.recommended_fix_type = 'NDB';

update approach_leg set recommended_fix_nav_id =
(
  select w.waypoint_id
  from waypoint w
  where approach_leg.recommended_fix_type = 'WAYPOINT' and approach_leg.recommended_fix_ident = w.ident and
  approach_leg.recommended_fix_region = w.region
) where approach_leg.recommended_fix_type = 'WAYPOINT';

-- Terminals -----------------------------------
update approach_leg set recommended_fix_nav_id =
(
  select n.ndb_id
  from ndb n join airport a on n.airport_id = a.airport_id
  where approach_leg.recommended_fix_type = 'TERMINAL_NDB' and approach_leg.recommended_fix_ident = n.ident and
  approach_leg.recommended_fix_region = n.region and a.ident = approach_leg.fix_airport_ident
) where approach_leg.recommended_fix_type = 'TERMINAL_NDB';

update approach_leg set recommended_fix_nav_id =
(
  select w.waypoint_id
  from waypoint w join airport a on w.airport_id = a.airport_id
  where approach_leg.recommended_fix_type = 'TERMINAL_WAYPOINT' and approach_leg.recommended_fix_ident = w.ident and
  approach_leg.recommended_fix_region = w.region and a.ident = approach_leg.fix_airport_ident
) where approach_leg.recommended_fix_type = 'TERMINAL_WAYPOINT';

----------------------------------------------------------------
-- Update navigation references for transition legs ------------

update transition_leg set recommended_fix_nav_id =
(
  select v.vor_id
  from vor v
  where transition_leg.recommended_fix_type = 'VOR' and transition_leg.recommended_fix_ident = v.ident and
  transition_leg.recommended_fix_region = v.region
) where transition_leg.recommended_fix_type = 'VOR';

update transition_leg set recommended_fix_nav_id =
(
  select n.ndb_id
  from ndb n
  where transition_leg.recommended_fix_type = 'NDB' and transition_leg.recommended_fix_ident = n.ident and
  transition_leg.recommended_fix_region = n.region
) where transition_leg.recommended_fix_type = 'NDB';

update transition_leg set recommended_fix_nav_id =
(
  select w.waypoint_id
  from waypoint w
  where transition_leg.recommended_fix_type = 'WAYPOINT' and transition_leg.recommended_fix_ident = w.ident and
  transition_leg.recommended_fix_region = w.region
) where transition_leg.recommended_fix_type = 'WAYPOINT';

-- Terminals -----------------------------------

update transition_leg set recommended_fix_nav_id =
(
  select n.ndb_id
  from ndb n join airport a on n.airport_id = a.airport_id
  where transition_leg.recommended_fix_type = 'TERMINAL_NDB' and transition_leg.recommended_fix_ident = n.ident and
  transition_leg.recommended_fix_region = n.region and a.ident = transition_leg.fix_airport_ident
) where transition_leg.recommended_fix_type = 'TERMINAL_NDB';

update transition_leg set recommended_fix_nav_id =
(
  select w.waypoint_id
  from waypoint w join airport a on w.airport_id = a.airport_id
  where transition_leg.recommended_fix_type = 'TERMINAL_WAYPOINT' and transition_leg.recommended_fix_ident = w.ident and
  transition_leg.recommended_fix_region = w.region and a.ident = transition_leg.fix_airport_ident
) where transition_leg.recommended_fix_type = 'TERMINAL_WAYPOINT';
