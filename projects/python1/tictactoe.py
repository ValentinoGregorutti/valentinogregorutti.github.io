from random import randrange


def create_empty_board():
    # The function creates an ampty board
    EMPTY = ""
    board = [[str((row*3) + (column+1)) for column in range(3)] for row in range(3)]
##    for row in range(3):
###        board[row]=[]
##        for column in range(3):
##            board[row][column] = str((row*3) + (column+1))
    board[1][1]="X"         # Computer moves first and in the middle
    display_board(board)
    return board


def display_board(board):
    # The function accepts one parameter containing the board's current status
    # and prints it out to the console.
    print("+-------+-------+-------+\n|       |       |       |")
    print("|  ", board[0][0], "  |  ", board[0][1], "  |  ", board[0][2], "  |")
    print("|       |       |       |\n+-------+-------+-------+\n|       |       |       |")
    print("|  ", board[1][0], "  |  ", board[1][1], "  |  ", board[1][2], "  |")
    print("|       |       |       |\n+-------+-------+-------+\n|       |       |       |")
    print("|  ", board[2][0], "  |  ", board[2][1], "  |  ", board[2][2], "  |")
    print("|       |       |       |\n+-------+-------+-------+")


def enter_move(board):
    # The function accepts the board's current status, asks the user about their move, 
    # checks the input, and updates the board according to the user's decision.
    while True:
        try:
            move = 0
            while move < 1 or move > 9:
                move = int(input("Enter your move: "))
        except:
            print("Please enter a integer number between 1 and 9.")
            continue                                            # if a bad input has been given then try another time

        if board[(move-1) // 3][(move-1) % 3] != str(move):     # if selected square is already used
            print("Please enter an empty square number.")
#           continue
        else:                                                   # if selected square is empty
            board[(move-1) // 3][(move-1) % 3] = "O"            # make the move
            display_board(board)                                # and show board with user's move
            return board


def make_list_of_free_fields(board):
    # The function browses the board and builds a list of all the free squares; 
    # the list consists of tuples, while each tuple is a pair of row and column numbers.
    empty_spaces = []
    for row in range(3):
        for column in range(3):
            if board[row][column] != "X" and board[row][column] != "O":
                empty_spaces.append((row,column))
#    print(empty_spaces)
    return empty_spaces


def victory_for(board, sign):
    # The function analyzes the board's status in order to check if 
    # the player using 'O's or 'X's has won the game
    return (
        board[0][0] == board[0][1] == board[0][2] == sign or        # first row
        board[1][0] == board[1][1] == board[1][2] == sign or        # second row
        board[2][0] == board[2][1] == board[2][2] == sign or        # third row
        board[0][0] == board[1][0] == board[2][0] == sign or        # first column
        board[0][1] == board[1][1] == board[2][1] == sign or        # second column
        board[0][2] == board[1][2] == board[2][2] == sign or        # third column
        board[0][0] == board[1][1] == board[2][2] == sign or        # down cross
        board[2][0] == board[1][1] == board[0][2] == sign           # up cross
        )


def draw_move(board):
    # The function draws the computer's move and updates the board.
    move = randrange(1, 10)
    while board[(move-1) // 3][(move-1) % 3] != str(move):          # find an empty square
        move = randrange(1, 10)
        
    board[(move-1) // 3][(move-1) % 3] = "X"                        # make the move
    display_board(board)                                            # and show board with pc's move





### program body  ###
board = create_empty_board()

while True:
    board = enter_move(board)                       # users moves
    if victory_for(board, "O"):
        print("You won!")
    elif make_list_of_free_fields(board) == []: print("Tie!")
    else:
        draw_move(board)                            # pc moves
        if victory_for(board, "X"): print("You loose!")
        elif make_list_of_free_fields(board) == []: print("Tie!")
        else: continue


    another_play = input("another play? ")
    if another_play == "y" or another_play == "Y":
        board = create_empty_board()
        continue

    break
print("Goodbye.")





