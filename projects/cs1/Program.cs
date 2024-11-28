/*
Suppose you want to create your own game. You might not be ready to develop a fully featured game, so you decide to start as small as possible. You want to move a character across the screen and make it consume an object. The object consume can affect the state of the player. To keep the game going, you wanted to regenerate the object in a new location once it has been consumed. You decide that you'll need to use methods to keep your game code organized.

In this module, you'll develop the following features of a mini-game application:

A feature to determine if the player consumed the food
A feature that updates player status depending on the food consumed
A feature that pauses movement speed depending on the food consumed
A feature to regenerate food in a new location
An option to terminate the game if an unsupported character is pressed
A feature to terminate the game if the Terminal window was resized
*/


/*
- The code declares the following variables:
    - Variables to determine the size of the Terminal window.
    - Variables to track the locations of the player and food.
    - Arrays `states` and `foods` to provide available player and food appearances
    - Variables to track the current player and food appearance

- The code provides the following methods:
    - A method to determine if the Terminal window was resized.
    - A method to display a random food appearance at a random location.
    - A method that changes the player appearance to match the food consumed.
    - A method that temporarily freezes the player movement.
    - A method that moves the player according to directional input.
    - A method that sets up the initial game state.

- The code doesn't call the methods correctly to make the game playable. The following features are missing:
    - Code to determine if the player has consumed the food displayed.
    - Code to determine if the food consumed should freeze player movement.
    - Code to determine if the food consumed should increase player movement.
    - Code to increase movement speed.
    - Code to redisplay the food after it's consumed by the player.
    - Code to terminate execution if an unsupported key is entered.
    - Code to terminate execution if the terminal was resized.

*/


using System;

Random random = new Random();
Console.CursorVisible = false;
int height = Console.WindowHeight - 1;
int width = Console.WindowWidth - 5;
bool shouldExit = false;

// Console position of the player
int playerX = 0;
int playerY = 0;

// Console position of the food
int foodX = 0;
int foodY = 0;
int foodRemaining = 0;
bool[] foodAte;

// Index of the current food
int food = 0;

// Available player and food strings
string[] states = { "('-')", "(^-^)", "(X_X)" };
string[] foods = { "@@@@@", "$$$$$", "#####" };

// Current player string displayed in the Console
string player = states[0];


InitializeGame();
while (!shouldExit)
{
    Move();
    if (TerminalResized())
        break;
    if (AteFood())
    {
        if (PlayerShouldFreeze())
            FreezePlayer();
        ChangePlayer();
        ShowFood();
    }
}
Console.Clear();
Console.CursorVisible = true;

if (TerminalResized())
    Console.WriteLine("Console was resized. Program exiting.");
else
    Console.WriteLine("Wrong key or escape pressed. Program exiting.");


// Returns true if the Terminal was resized 
bool TerminalResized()
{
    return height != Console.WindowHeight - 1 || width != Console.WindowWidth - 5;
}

// Displays random food at a random location
void ShowFood()
{
    // Update food to a random index
    food = random.Next(0, foods.Length);
    foodRemaining = foods[food].Length;
    // restore uneaten food array
    foodAte = new bool[foodRemaining];
    for (int i = 0; i < foodAte.Length; i++)
        foodAte[i] = false;

    // Update food position to a random location but not on the same row
    // When this method is called to redraw food, player and food are on the same line
    foodX = random.Next(0, width - foodRemaining);
    while (foodY == playerY)
        foodY = random.Next(0, height - 1);

    // Display the food at the location
    Console.SetCursorPosition(foodX, foodY);
    Console.Write(foods[food]);
}

// Changes the player to match the food consumed
void ChangePlayer()
{
    player = states[food];
    Console.SetCursorPosition(playerX, playerY);
    Console.Write(player);
}

// Temporarily stops the player from moving
void FreezePlayer()
{
    System.Threading.Thread.Sleep(1000);
    player = states[0];
}

// Reads directional input from the Console and moves the player
void Move()
{
    int lastX = playerX;
    int lastY = playerY;
    bool superSpeed = SuperSpeed();

    switch (Console.ReadKey(true).Key)
    {
        case ConsoleKey.UpArrow:
            playerY--;
            break;
        case ConsoleKey.DownArrow:
            playerY++;
            break;
        case ConsoleKey.LeftArrow:
            playerX--;
            if (superSpeed)
                playerX -= 2;
            break;
        case ConsoleKey.RightArrow:
            playerX++;
            if (superSpeed)
                playerX += 2;
            break;
        case ConsoleKey.Escape:
            shouldExit = true;
            break;
        default:
            shouldExit = true;
            break;
    }

    // needed when resizing into smaller console 
    if (TerminalResized())
        return;

    // Clear the characters at the previous position
    Console.SetCursorPosition(lastX, lastY);
    for (int i = 0; i < player.Length; i++)
        Console.Write(" ");

    // Keep player position within the bounds of the Terminal window
    playerX = (playerX < 0) ? 0 : (playerX >= width ? width : playerX);
    playerY = (playerY < 0) ? 0 : (playerY >= height ? height : playerY);

    // check if player ate some food
    if (playerY == foodY)
    {
        if (playerX - foodX <= foods[food].Length && playerX - foodX >= 0)  // @@@@@('-')
        {
            for (int i = foodAte.Length - 1; i >= playerX - foodX; i--)
                foodAte[i] = true;
        }
        else if (foodX - playerX <= player.Length - 1 && foodX - playerX > 0)  // ('-')@@@@@
        {
            for (int i = 0; i < foodAte.Length - (foodX - playerX); i++)
                foodAte[i] = true;
        }


    }

    // Draw the player at the new location
    Console.SetCursorPosition(playerX, playerY);
    Console.Write(player);
}

// Clears the console, displays the food and player
void InitializeGame()
{
    Console.Clear();
    ShowFood();
    Console.SetCursorPosition(0, 0);
    Console.Write(player);
}

// checks weather all food has been ate
bool AteFood()
{
    bool ateAllFood = true;
    for (int i = 0; i < foodAte.Length; i++)
        ateAllFood &= foodAte[i];
    return ateAllFood;
}

bool PlayerShouldFreeze()
{
    if (foods[food] == "#####")
        return true;
    return false;
}


bool SuperSpeed()
{
    if (player == "(^-^)")
        return true;
    return false;
}