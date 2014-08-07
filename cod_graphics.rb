class CoDGraphics

  TITLE_SEPERATOR = '   ' + '='*140 + "\n"

  TITLE_GFX = <<-CALLOFDUTY
                   $$$$$$\\   $$$$$$\\  $$\\       $$\\              $$$$$$\\  $$$$$$$$\\       $$$$$$$\\  $$\\   $$\\ $$$$$$$$\\ $$\\     $$\\ 
                  $$  __$$\\ $$  __$$\\ $$ |      $$ |            $$  __$$\\ $$  _____|      $$  __$$\\ $$ |  $$ |\\__$$  __|\\$$\\   $$  |
                  $$ /  \\__|$$ /  $$ |$$ |      $$ |            $$ /  $$ |$$ |            $$ |  $$ |$$ |  $$ |   $$ |    \\$$\\ $$  / 
                  $$ |      $$$$$$$$ |$$ |      $$ |            $$ |  $$ |$$$$$\\          $$ |  $$ |$$ |  $$ |   $$ |     \\$$$$  /  
                  $$ |      $$  __$$ |$$ |      $$ |            $$ |  $$ |$$  __|         $$ |  $$ |$$ |  $$ |   $$ |      \\$$  /   
                  $$ |  $$\\ $$ |  $$ |$$ |      $$ |            $$ |  $$ |$$ |            $$ |  $$ |$$ |  $$ |   $$ |       $$ |    
                  \\$$$$$$  |$$ |  $$ |$$$$$$$$\\ $$$$$$$$\\        $$$$$$  |$$ |            $$$$$$$  |\\$$$$$$  |   $$ |       $$ |    
                   \\______/ \\__|  \\__|\\________|\\________|       \\______/ \\__|            \\_______/  \\______/    \\__|       \\__|    
  CALLOFDUTY

	FLAG_MAP = '                                                                                                                       N..   
                              N.  .                                                                                   O8NN.  
                              NND DD888..                                    .                                        ZO8DN  
                              IN..DDD888OOZZ$$ZO8O....................  .   Z8                                       .:::::  
                              MNNNND8DD888.ZZ$$ZO 87MMN.D888D ,DDDDDD8OZO8ND8Z8NN8                                  :::::    
                                MNN:  DDD8. .ZZ$$. 8NN~  +888. DDDDDDD8::::::::::,8,.                          .~ZOD~:::     
                             $..NMNNNNNDDD888OOZZ$ZO8DN=M ND8888DD:,,,,::::::::::::    ,,.  .:.              .888OOODND      
                            .8DDNNMMNNNNDDDD88OOZZ$$ZO8DNMMNDD8888D,,,,,:::::::::::,.,,,,,,,::              .DD888OOO8N      
                           .OO8DDNNMMMNNDDDDD888OOZZ$.O8DNM NND8O .D,,,,,:::::::::::,8DNNDDD8OOZ.            ,,,,88OOO8      
                          .:ZOO8D ..NMM:  NDD8. .8OO,  ZO8D  MNDD .88,,,,OOO8DNNDD8OZO8DNNDDD88OZ        ...M,,,,,,,:ZO8D    
                          .. OZOO.8.DNMMMNNNNDDD888OZZZ$$ZO8NMMMND8888DDDD8OZ8DNNDD8OZO8DNNDDD8O +O      NMMMM,,,,,,,:.      
                          .88OOZOO88DDNNMMNNNNDDDD888OOZZ$ZO8.NMMNOD88DDDDD8OZO8DNND8OZO8DNNNDD88OZ.     NNMMMMNO,,,.,       
                          NDD88OOZOO88DDNM.MNNNNDDD8888.  $$.  DNN  DD8DDDDD8OZO8DNN~:::,,,,,,,,,,:    ,,:::MMMMNOO..        
                         NNN?.  8OZ..  DDN. MMNNN, DD888 .ZZ$..8DNMMNND8DDDD,,:::::::::::,,,,,,,,,.  ::::::::::MMN8O         
                         ?NNNI. 88OO.OO88DNNNMMNNNNDDDD888OZZ$$ZO8DNMMND:,,,,,,::::::::::::,,,,,,,,,:::::::::::,NMM.         
                         NNNNNNNDD88OZZOO88DNNMMMNNNDDDD8888?:::::::::::,,,,,,,,::::::::::::,,,,,,,,,::::::::::: ,,          
                         .NNNN::::,,,,,,,:::::::::::,,,,,,,,,::::::::::::,,,,,,OZOO88DDNNNDD888DNMNNDD8OOO::::::: ,,         
                          :::::::::,,,,,,,,::::::::::,,,,,,,,,::::::::::::,,,,,D8ZOO88DNNNNDD888DNNNNDD8OOO88DDNNN           
                          ::::::::::,,,,,,,::::::::::,,,,,,,,,::::::::::,$DNMMND8OOO88DNNNNDD888DNNNNDD8OOO88DDNN.          
                           :::::::::::,,,,,,,:::::::$OZOO88DDNNNMNND88OZOO8DDNNMND8OZO88DNNND::::8DDNNNDD88OOO8DDNN          
                            ::::::ZZOO88DDDNNMNNNDD88OOZZO88DDNNNMNNDD8OOOO88DNNMND,,,:::::::::::,,,,,,,,,,::::::::N.        
                            888OOOOZZOO888DDNNNNNNDD88OOZZOO8DDNNNMNNDD8OZZO88DNNMN,,,,:::::::::::,,,,,,,,,,:::::::          
                            .888OOOOZZOO888DDNNMNNNDD888OOZOO88DI.,:::::::::::::,,,,,,,,::::::::::::,,,,,,,,,:::::           
                             D888OOOOZZOO888DDNNNNNNDD88::::,,,,,,,,,::::::::::::,,,,,,,,:::::::::Z88DDNNNDD88OO8            
                             .D888OI::::::::,,,,,,,::::::::::,,,,,,,,,::::::::::::,,,,OZOO88DDNMNND888DDNNNDD88.             
                                ,,::::::::::,,,,,,,,::::::::::,,,,,,,,,::::::::::::,,NDOZOO88DDNMNNDD888DNNNDD.              
                                  ,:::::::::::,,,,,,:::::::::::,,,,,,,$NND8OOZO88DDNM8ND8ZOO88DDNMNNDD88:=NN,.               
                                   ,:::::::::::,,,,,,,:::::~ZOO88DDNNNMNNDD8OOZO88DDNMMND,,,,,:,=,:::::::,,,                 
                                       ::OO88DDDNNNNNNDDD88OOZOO88DDNNNMNNDD8OOZOO8DDNNM,,,,,,,:::::::::::,                  
                                         ZOO888DDNNNNNNDDD88OOZOOO8DDDNNMNNDD88OZOO8DDNN,,,,,,,,:::::::::::                  
                                           .O888DDNNNNNNDDD88OOZOO888DDNNMNNND,::::Z8DDN:,,,,,,,,::::::::::                  
                                              .          NDD888:::::,,,,,,,,,::::::::::::$ZOO88DDNMNNDD8888D                 
                                                          ,::::::::::,,,,,,,,,:::::::::::D8Z       M.  .8888+                
                                                           ,:::::::::::,,,,,,,,,:::::::::N:8             88888               
                                                            .,::   :::::,,,,,,,,      : :MN              D888I               
                                                                   .8DDNNNMNND.        . .. .             ,,:::.             
                                                                    .8DDNNN.                               ,,:O8             
                                                                      8DDDN                                 ,ZZO             
                                                                       88DD                                   Z.             
                                                                        .8D.                                               
                                                            PRESS [Return] KEY TO CONTINUE'

  EMBIGGENS = <<RONALD
                               !
           H|H|H|H|H           H__________________________________
           H|H|H|H|H           H|* * * * * *|---------------------|
           H|H|H|H|H           H| * * * * * |---------------------|
           H|H|H|H|H           H|* * * * * *|---------------------|
           H|H|H|H|H           H| * * * * * |---------------------|
           H|H|H|H|H           H|---------------------------------|
        ===============        H|---------------------------------|
          /| _   _ |\\          H|---------------------------------|
          (| O   O |)          H|---------------------------------|
          /|   U   |\\          H-----------------------------------
           |  \\=/  |           H
            \\_..._/            H
            _|\\I/|_            H             " A NOBLE SPIRIT
    _______/\\| H |/\\_______    H                 EMBIGGENS
   /       \\ \\   / /       \\   H             THE SMALLEST MAN "
  |         \\ | | /         |  H                  
  |          ||o||          |  H                 - GEORGE WASHINGTON
  |    |     ||o||     |    |  H                   1776
  |    |     ||o||     |    |  H    
RONALD

  def self.display_title
    puts TITLE_SEPERATOR, TITLE_GFX, TITLE_SEPERATOR
    puts ""
 end

	def self.display_splash
    self.clear_screen

    print TITLE_SEPERATOR, TITLE_GFX, TITLE_SEPERATOR, FLAG_MAP
	end

  def self.display_outro
    puts EMBIGGENS
    puts ""
  end

	def self.clear_screen
		system "clear" or system "cls"
	end

end
