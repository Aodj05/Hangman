# frozen_string_literal: true

require 'json'

# game save/load serialize

module Serialized
    EXTENSION = 'json'
    SERIALIZER = JSON
    SAVED_DIR = './saves'

    def serialize
        to_serialize = inst_vars.each_with_object({}) do |var, object|
            object[var] = inst_var_get var
            object
        end
        SERIALIZER.dump to_serialize
    end

    def deserialize(string)
        object = SERIALIZER.parse string
        object.each do |var, value|
            inst_var_set var, value
        end
    end

    def chk_sav_dir
        Dir.mkdir SAVED_DIR unless Dir.exist? SAVED_DIR
    end

    def saved_games
        chk_sav_dir
        Dir.glob "#{SAVED_DIR}/*.json"
    end

    def game_list
        saved_games.each_with_index.each_with_object({}) do |(file, index), hash|
            hash[index+1] = file
            hash
        end
    end

    def savefile_name
        loop do
            filename = ''
            filename = gets.chomp while filename.empty?
            filename += ".#{EXTENSION}"
            break filename unless File.exist? "./saved_games/#{filename}"
            puts "file already exists"
        end
    end

    def load_screen
        sel_option = gets.chomp until game_list.key?(sel_option.to_i) || %w[b e].include?(sel_option)
        
        sel_option
    end

    def game?(sel_option)
        game_list.key? sel_option.to_i
    end

    def game_to_file
        chk_sav_dir
        filename = savefile_name
        File.open("./saved_games/#{filename}, 'w'"){|file| file.puts serialize}
    end
end