using System;
using System.Threading;

enum AquaState
{
    SN, // Normal
    SW, // Warning
    SC  // Critical
}

class AquacultureController
{
    public AquaState CurrentState = AquaState.SN;

    public string StateText()
    {
        return CurrentState switch
        {
            AquaState.SN => "Normal",
            AquaState.SW => "Warning",
            AquaState.SC => "Critical",
            _ => "Unknown"
        };
    }

    public ConsoleColor StateColor()
    {
        return CurrentState switch
        {
            AquaState.SN => ConsoleColor.Green,
            AquaState.SW => ConsoleColor.Yellow,
            AquaState.SC => ConsoleColor.Red,
            _ => ConsoleColor.White
        };
    }

    public void UpdateStateForced(int force)
    {
        if (force == 0)
            CurrentState = AquaState.SN;
        else if (force == 1)
            CurrentState = AquaState.SW;
        else
            CurrentState = AquaState.SC;
    }

    public void PrintActuators()
    {
        Console.WriteLine("\n=== ACTUATORS ===");

        if (CurrentState == AquaState.SN)
        {
            Console.WriteLine("Pump          : 0");
            Console.WriteLine("Aerator       : 1");
            Console.WriteLine("Valve         : 0");
            Console.WriteLine("Heater        : 0");
            Console.WriteLine("UV            : 0");
            Console.WriteLine("Feeder        : 1");
        }
        else if (CurrentState == AquaState.SW)
        {
            Console.WriteLine("Pump          : 1");
            Console.WriteLine("Aerator       : 1");
            Console.WriteLine("Valve         : 1");
            Console.WriteLine("Heater        : 0");
            Console.WriteLine("UV            : 0");
            Console.WriteLine("Feeder        : 1");
        }
        else if (CurrentState == AquaState.SC)
        {
            Console.WriteLine("Pump          : 1");
            Console.WriteLine("Aerator       : 1");
            Console.WriteLine("Valve         : 1");
            Console.WriteLine("Heater        : 1");
            Console.WriteLine("UV            : 1");
            Console.WriteLine("Feeder        : 0");
        }
    }
}

class Program
{
    static void Main()
    {
        AquacultureController aq = new AquacultureController();
        Random rnd = new Random();

        Console.WriteLine("=== SMART AQUACULTURE AUTOMATIC SIMULATION ===\n");
        Console.WriteLine("Tekan CTRL + C untuk stop.\n");

        while (true)
        {
            Console.WriteLine("--------------------------------------------");

            // FORCE state muncul bergantian
            int forcedState = rnd.Next(0, 3);

            aq.UpdateStateForced(forcedState);

            Console.ForegroundColor = aq.StateColor();
            Console.WriteLine($">>> STATE = {aq.CurrentState} ({aq.StateText()})");
            Console.ResetColor();

            aq.PrintActuators();

            Thread.Sleep(1000);
        }
    }
}
