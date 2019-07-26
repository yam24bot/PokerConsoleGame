class Game

Card = Struct.new(:rank, :suit,:rank_id)
def deck
ranks = %w{2 3 4 5 6 7 8 9 10 J Q K A}
@suits = ['Spades', 'Hearts', 'Diamonds', 'Clubs']
@cards=Array.new(7)
stack_of_cards = @suits.each_with_object([]) do |suit,res|
  ranks.size.times do |i|
    res << Card.new(ranks[i], suit,i + 1)
  end
end

#puts stack_of_cards

stack_of_cards.shuffle!


# @cards.sort_by { |card| card[:rank_id] } # SORTING CARDS BY WEIGHT
#puts stack_of_cards[0] = {rank: "4", suit: "Spades", rank_id: 3 }

  #stack_of_cards[0] = Card.new("K", "Clubs", 12)
  #stack_of_cards[1] = Card.new("5", "Hearts", 4)
  #stack_of_cards[2] = Card.new("5", "Diamonds", 4)
  #stack_of_cards[3] = Card.new("K", "Hearts", 12)
  #stack_of_cards[4] = Card.new("K", "Diamonds", 12)
  #stack_of_cards[5] = Card.new("8", "Hearts", 7)
  #stack_of_cards[6] = Card.new("6", "Spades", 5)


@full_house_counter = false
@pair_counter = false
@three_counter = false
@four_counter = false
@two_pair_counter = false
@flush_counter = false
@straight_counter = false


(0...7).each { |k|
  @cards[k] = stack_of_cards[k]
  puts "card №#{k}: suit - #{@cards[k].suit} | rank - #{@cards[k].rank} | weight - #{@cards[k].rank_id}"
}
end

def straight?
  result = []
  counter = 1
  @cards.each do |i|
    if result.empty?
      result << i
    else
      case result.last.rank_id - i.rank_id
      when 1
        result << i
        counter += 1
      when 0
        result << i
      else
        if counter >= 5
          result
        else
          result = [i]
          counter = 1
        end
      end
    end
  end
  if counter >= 5
    @straight_counter = true
  else
    []
  end
end





def find_suit(suits)
  result = []
  @cards.each do |i|
    result.push(i) if i.suit == suits
  end
  #sort(result)
  result
end

def flush?
  spd=0
  clb=0
  hrt=0
  dmnd=0
  @cards.each do |i|
    case i.suit
    when 'Spades'
      spd += 1
    when 'Clubs'
      clb += 1
    when 'Diamonds'
      dmnd += 1
    when 'Hearts'
      hrt += 1
    end
  end
  if spd >= 5
    find_suit('Spades')
    @flush_counter =true
  end
  if clb >= 5
    find_suit('Clubs')
    @flush_counter=true
  end
  if dmnd >= 5
    find_suit('Diamonds')
    @flush_counter=true
  end
  if hrt >= 5
    find_suit('Hearts')
    @flush_counter=true
  end
end


def pair?
  @resp = []
  @cards.sort_by { |card| card[:rank_id] } # SORTING CARDS BY WEIGHT
  (0...7).each { |k|
    (k+1...7).each { |j|
    if @cards[k].rank_id == @cards[j].rank_id
      @resp << @cards[k].rank_id
      @pair_counter = true
      #puts "pair of #{@cards[k].rank}"
      break
    end
    }
    }
  @resp.uniq!
end

#pair?


def three_of_rank?
  @rest = []
  (0...7).each { |k|
    counter = 1
    (k+1...7).each { |j|
      if @cards[k].rank_id == @cards[j].rank_id
        counter +=1
      end
      if counter == 3
        @rest << @cards[k].rank_id
        @three_counter = true
        #puts "three of #{@cards[k].rank}"
      end
    }
    }
  @rest.uniq!
end
#three_of_rank?



def four_of_rank?
  (0...7).each { |k|
    counter = 1
    (k + 1...7).each {|j|
      if @cards[k].rank_id == @cards[j].rank_id
        counter += 1
      end
      if counter == 4
        @four_counter = true
        #puts "four of #{@cards[k].rank}"
      end
    }
    }
end
#four_of_rank?


def full_house?
  if @three_counter && @pair_counter && @resp.each {|k| k} != @rest.each {|k| k }
    @full_house_counter = true
  end
end



def run
  deck
  three_of_rank?
  pair?
  four_of_rank?
  flush?
  straight?
  full_house?
  if @four_counter
    puts "four"
    @full_house_counter = false
    @flush_counter = false
    @straight_counter = false
    @three_counter = false
    @two_pair_counter = false
    @pair_counter = false
  elsif @full_house_counter
    puts "full house"
    @flush_counter = false
    @straight_counter = false
    @three_counter = false
    @two_pair_counter = false
    @pair_counter = false
  elsif @flush_counter
    puts "flush"
    @straight_counter = false
    @three_counter = false
    @two_pair_counter = false
    @pair_counter = false
  elsif @straight_counter
    puts "straight"
    @three_counter = false
    @two_pair_counter = false
    @pair_counter = false
  elsif @three_counter
    puts "three"
    @two_pair_counter = false
    @pair_counter = false
  elsif @two_pair_counter
    puts "two pair"
    @pair_counter = false
  elsif @pair_counter
    puts "pair"
  else
    puts "kicker"
  end
end
end

g = Game.new
g.run
