
class WRandomString
{
    static WRandomString Create()
    {
        return WRandomString(new("WRandomString"));
    }

    array<string> items;
    array<double> weights;

    void Add(string item, double weight = 1)         
    { 
        items.Push(item);
        weights.Push(weight);
    }

    string Pick()
    {
        if(items.Size() == 0)
        {
            ThrowAbortException("WRandomString.Pick() Error: No item's have been added to pick from.");
            return "";
        }
        if(items.Size() == 1)
        {
            Console.PrintF("\c[Yellow]WRandomString.Pick() Warning: theres only 1 item to pick from.");
            return items[0];
        }
        else
        {
            double total = 0;
            
            for (int i = 0; i < weights.Size(); i++) 
            {
                total += weights[i];
            }

            double random = frandom(0, total);
            double added = 0;

            for (int i = 0; i < items.Size(); i++) 
            {
                added += weights[i];
                if (random < added) 
                {
                    return items[i];
                }
            }
        }

        // should never reach this point but i have to put this here
        ThrowAbortException("WRandomString.Pick() Error: How?");
        return ""; 
    }
}

class WRandomInt
{
    static WRandomInt Create()
    {
        return WRandomInt(new("WRandomInt"));
    }

    array<int> items;
    array<double> weights;

    void Add(int item, double weight = 1)         
    { 
        items.Push(item);
        weights.Push(weight);
    }

    int Pick()
    {
        if(items.Size() == 0)
        {
            ThrowAbortException("WRandomInt.Pick() Error: No item's have been added to pick from.");
            return 0;
        }
        if(items.Size() == 1)
        {
            Console.PrintF("\c[Yellow]WRandomInt.Pick() Warning: theres only 1 item to pick from.");
            return items[0];
        }
        else
        {
            double total = 0;
            
            for (int i = 0; i < weights.Size(); i++) 
            {
                total += weights[i];
            }

            double random = frandom(0, total);
            double added = 0;

            for (int i = 0; i < items.Size(); i++) 
            {
                added += weights[i];
                if (random < added) 
                {
                    return items[i];
                }
            }
        }

        // should never reach this point but i have to put this here
        ThrowAbortException("WRandomInt.Pick() Error: How?");
        return 0; 
    }
}

class WRandomDouble
{
    static WRandomDouble Create()
    {
        return WRandomDouble(new("WRandomDouble"));
    }

    array<double> items;
    array<double> weights;

    void Add(double item, double weight = 1)         
    { 
        // if weight is 0 or less, ignore it, useful for cvars that provide weights and want to turn off certain items 
        // example: tri_trasher_weight = 0 will never spawn a trasher
        if(weight <= 0) { return; }
        items.Push(item);
        weights.Push(weight);
    }

    double Pick()
    {
        if(items.Size() == 0)
        {
            ThrowAbortException("WRandomDouble.Pick() Error: No item's have been added to pick from.");
            return 0;
        }
        if(items.Size() == 1)
        {
            Console.PrintF("\c[Yellow]WRandomDouble.Pick() Warning: theres only 1 item to pick from.");
            return items[0];
        }
        else
        {
            double total = 0;
            
            for (int i = 0; i < weights.Size(); i++) 
            {
                total += weights[i];
            }

            double random = frandom(0, total);
            double added = 0;

            for (int i = 0; i < items.Size(); i++) 
            {
                added += weights[i];
                if (random < added) 
                {
                    return items[i];
                }
            }
        }

        // should never reach this point but i have to put this here
        ThrowAbortException("WRandomDouble.Pick() Error: How?");
        return 0; 
    }
}
