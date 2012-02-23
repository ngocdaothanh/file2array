using System;
using System.Reflection;

public class DataLoader
{
	public static byte[] Load(string className)
	{
		Type      t = Type.GetType(className);
		FieldInfo f = t.GetField("data");
		return (byte[]) f.GetValue(null);
	}
}
