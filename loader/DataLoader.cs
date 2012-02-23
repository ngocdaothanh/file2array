using System;
using System.Reflection;

/*
The class should look like this:

public class Level123 {
    public static byte[] data =
    {
        0x53, 0x65, 0x65
    };
}

=> byte[] mydata = DataLoader.Load("Level123");
*/
public class DataLoader
{
	public static byte[] Load(string className)
	{
		Type      t = Type.GetType(className);
		FieldInfo f = t.GetField("data");
		return (byte[]) f.GetValue(null);
	}
}
