class WRandom_String
{
    static WRandom_String Create()
    {
        return WRandom_String(new("WRandom_String"));
    }

    array<string> items;
    array<int> weights;

    void Add(string item, int weight = 1)
    {
        if(weight <= 0) { return; }
        items.Push(item);
        weights.Push(weight);
    }

    string Pick()
    {
        if(items.Size() == 0)
        {
            ThrowAbortException("WRandom_String.Pick() Error: No item's have been added to pick from.");
            return "";
        }
        if(items.Size() == 1)
        {
            Console.PrintF("\c[Yellow]WRandom_String.Pick() Warning: theres only 1 item to pick from.");
            return items[0];
        }
        else
        {
            int total = 0;

            for (int i = 0; i < weights.Size(); i++)
            {
                total += weights[i];
            }

            int rand = random[weighed_rng](1, total);
            int added = 0;

            for (int i = 0; i <= items.Size(); i++)
            {
                added += weights[i];
                if (rand < added)
                {
                    return items[i];
                }
            }
        }

        ThrowAbortException("WRandom_String.Pick() Error: How?");
        return "";
    }
}

class WRandom_Int
{
    static WRandom_Int Create()
    {
        return WRandom_Int(new("WRandom_Int"));
    }

    array<int> items;
    array<int> weights;

    void Add(int item, int weight = 1)
    {
        if(weight <= 0) { return; }
        items.Push(item);
        weights.Push(weight);
    }

    int Pick()
    {
        if(items.Size() == 0)
        {
            ThrowAbortException("WRandom_Int.Pick() Error: No item's have been added to pick from.");
            return 0;
        }
        if(items.Size() == 1)
        {
            Console.PrintF("\c[Yellow]WRandom_Int.Pick() Warning: theres only 1 item to pick from.");
            return items[0];
        }
        else
        {
            int total = 0;

            for (int i = 0; i < weights.Size(); i++)
            {
                total += weights[i];
            }

            int rand = random[weighed_rng](1, total);
            int added = 0;

            for (int i = 0; i < items.Size(); i++)
            {
                added += weights[i];
                if (rand <= added)
                {
                    return items[i];
                }
            }
        }

        ThrowAbortException("WRandom_Int.Pick() Error: This shouldnt happen?");
        return 0;
    }
}

class WRandom_Double
{
    static WRandom_Double Create()
    {
        return WRandom_Double(new("WRandom_Double"));
    }

    array<double> items;
    array<int> weights;

    void Add(double item, int weight = 1)
    {
        if(weight <= 0) { return; }
        items.Push(item);
        weights.Push(weight);
    }

    double Pick()
    {
        if(items.Size() == 0)
        {
            ThrowAbortException("WRandom_Double.Pick() Error: No item's have been added to pick from.");
            return 0;
        }
        if(items.Size() == 1)
        {
            Console.PrintF("\c[Yellow]WRandom_Double.Pick() Warning: theres only 1 item to pick from.");
            return items[0];
        }
        else
        {
            int total = 0;

            for (int i = 0; i < weights.Size(); i++)
            {
                total += weights[i];
            }

            int rand = random[weighed_rng](1, total);
            int added = 0;

            for (int i = 0; i <= items.Size(); i++)
            {
                added += weights[i];
                if (rand < added)
                {
                    return items[i];
                }
            }
        }

        ThrowAbortException("WRandom_Double.Pick() Error: How?");
        return 0;
    }
}
