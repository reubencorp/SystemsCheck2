require 'sinatra'
require "rubygems"
require "json"


get '/leaderboard' do
	
	file = open("data.txt")
	#read file
	string = file.read
	#parse json string
	parsed = JSON.parse(string) # returns a hash
	
	#my declare 3 arrays
	teams = []
	total_wins = []
	total_losses  = []
	#number of teams
	size = 0
	#for each records
	parsed.each do |key, value|
		#read home team, away team, score of home team, score of away team
		home_team = value['home_team']
		away_team = value['away_team']
		home_score = value['home_score']
		away_score = value['away_score']
		
		#found flag
		found = 0
		#find if home team string is in teams array
		teams.each do|n|
			if n == home_team
				found = 1
				break
			end
		end		
		
		if found == 0
			#add to 3 arrays
			teams << home_team
			total_wins << 0
			total_losses << 0
			size = size + 1
		end		
		
		found = 0
		
		teams.each do|n|
			if n == away_team
				found = 1
				break
			end
		end		
		
		if found == 0
			#add to 3 arrays
			teams << away_team
			total_wins << 0
			total_losses << 0
			size = size + 1
		end
		
		#I have to find the winner, looser...hmmm not bad
		winner = ""
		looser = ""
		#winner is home team
		if Integer(home_score) > Integer(away_score)
			winner = home_team;
			looser = away_team;
		end
		#winner is away team
		if Integer(home_score) < Integer(away_score)
			winner = away_team;
			looser = home_team;
		end
		
		#print for debug
		
		i = 0
		#if winner found, not tie
		if winner != ""
			#find position in arrays
			teams.each do|n|
				if n == winner
					#increase the total wins
					total_wins[i] = total_wins[i] + 1
					break
				end
				i = i + 1
			end	
		end
		i = 0
		#if looser found, not tie
		if looser != ""
			#find position in arrays
			teams.each do|n|
				if n == looser
					#increase the total looses
					total_losses[i] = total_losses[i] + 1
					break
				end
				i = i + 1
			end	
		end
	end
	#sort teams based on win, loose
	i = 0
	j = 0
	#for each team
	while i < size - 1 do	
		j = i + 1
		#for other teams that follow team i
		while j < size do	
			#compare wins descending, then looses ascending
			if total_wins[i] < total_wins[j] || (total_wins[i] == total_wins[j] && total_losses[i] > total_losses[j])
				#swap team name
				aTeam = teams[i]
				teams[i] = teams[j]
				teams[j] = aTeam
				#swap total win
				score = total_wins[i]
				total_wins[i] = total_wins[j]
				total_wins[j] = score
				#swap total looses
				score = total_losses[i]
				total_losses[i] = total_losses[j]
				total_losses[j] = score
			end
			#next team (follow team i)
			j = j + 1
		end
		#next team
		i = i + 1
	end
	#result stores rows in table
	result = ""
	i = 0
	#for each team
	teams.each do|n|
		result = result + "<tr>"
		result = result + "<td>"
		result = result + "<a href='/details/#{n}/#{total_wins[i]}/#{total_losses[i]}'>#{n}</a>"
		result = result + "</td>"
		result = result + "<td>"
		result = result + total_wins[i].to_s
		result = result + "</td>"
		result = result + "<td>"
		result = result + total_losses[i].to_s
		result = result + "</td>"
		result = result + "</tr>"
		i = i + 1
	end
	
	"<center>
	<table border='1'>
		<tr>
		<th>
		Team
		</th>
		<th>
		Win
		</th>
		<th>
		Losses
		</th>
		</tr>
		#{result}
	</table>
	</center>
	"	
end
#GET /detals/team/wins/looses
get '/details/:team/:wins/:looses' do	
	"<center>
	Team: #{params[:team]}<br/>
	Wins: #{params[:wins]}<br/>
	Looses: #{params[:looses]}<br/>
	</center>
	"
end