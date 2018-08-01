# Vancouver Fruit Tree Project application #

This application represents a result of collaboration between a non-for-profit orgnainzation Vancouver Fruit Tree Project (VFTP) [their website](https://vancouverfruittree.com) and a group of Computer Science students from Simon Fraser Univeristy. The initial version of this application was developed for CMPT 276 - Introduction to Software Engineering class during Summer 2018 Semester. Orginal team members:

1. Artem Gromov
2. Cameron Savage
3. Oliver Fujiki
4. Chun Kei Li (Argus)
5. Jeff Lee

You can contact the current development team at: 276Harvest8 at gmail . com

## Summary ##
Vancouver Fruit Tree Project (VFTP) is an orgnaization that works to adress the problem of food waste and food security. The organization connects Fruit Tree owners with the volunteers helping harvest excess produce. The primary purpose of this application is to aid VFTP with administration of their pick events.

Currently application supports the following roles:
* Adminstrator 
* Leader
* Volunteer

Administrator role is reserved for the staff of VFTP. This role has permissions to create or delete pick events. They are able to see all available pick events and their progress. They can see the list of the users and grant the role of users who are leaders or volunteers. Administrator can see the charts visulizing past pick event yilds.

Leader role is reserved for pick leaders that are screened and hired by VFTP. This role alllows a user to sign up to be a leader of a pick. They can see a list of volunteers signed up for their events. This user can only see an approximate location of an event before they sign up. The precise adress is revealed as soon as pick leader signs up for the pick event.  This user can start a pick, take volunteer attendance and log the yield for the pick event.

Volunteer is an role for volunteer fruit pickers. Anyone with a valid email adress can sign up to become a volunteer. All new users are volunteers by default. User with this role can see a list of available picks that are have a team leader and which have availale spots for volunteers (If the limit is specified). Volunteer can sign up for the pick event.

## VFTP Process##
The process starts with coordinator(Administrator) contacting fruit owners and creating a new pick event. They are required to specify the drop off location for the community partner.

Then a pick lead can sign up for a pick event if non of the other pick leaders signed up for it. Once they signed up, they would be able to see the exact location for a pick.

Once a pick has a leader it becomes visible to volunteers. They can signe up if there are spaces left for volunteers. Once they signed up, they would be able to see the exact location for a pick.

After the pick is over the pick leader can log the yield for the pick event mark volunteers who have attened the event. Once complete the yield for pick leaders gets added up and now leader can see their rank in the leaderboard.
 
## How to test ##
To login as an adminstrator:
1. User ID: tomgromov
2. PW: Test123! 
Admin can create new pick event by clicking + in the available picks table. Admin can also delete a pick by swiping the cell to the right in the available picks.
Admin can see the visualization for the yield

To login as a team lead:
1. User ID: TestLead
2. PW: Test123!
Leader can start a pick that they are leaders of, they can log the yield and mark volunteers as present.

To login as a Volunteer:
1. User ID: testaccount
2. PW: Test123!
