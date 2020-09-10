using System;
using System.Net.Http;
using System.Threading.Tasks;
using System.Text;
using System.Xml.Linq;
using System.Linq;

namespace XMLparserTest
{
    class Program
    {
        static HttpClient client = new HttpClient();

        //Получение данных от ЦБРФ
        static async Task<String> GetHongKongDollarValue()
        {
            HttpResponseMessage response = await client.GetAsync("http://www.cbr.ru/scripts/XML_daily.asp");
            if (response.IsSuccessStatusCode)
            {
                //Получаем содержимое ответа
                byte[] xmlResponse = await response.Content.ReadAsByteArrayAsync();
                //Преобразуем в кодировку UTF8
                string xmldocStr = Encoding.UTF8.GetString(xmlResponse, 0, xmlResponse.Length);
                //Преобразуем в XML и ищем необходимый элемент Value по ID валюты 
                string hkDollar = XElement.Parse(xmldocStr).Elements("Valute").Where(e => (string)e.Attribute("ID").Value == "R01200")
                                         .Select(e => e.Element("Value").Value)
                                         .FirstOrDefault()
                                         .ToString();
                return hkDollar;
            }
            else
            {
                return "Not Found"; 
            }
            

        }
        static async Task RunAsync()
        {
            //Чистим заголовки
            client.DefaultRequestHeaders.Accept.Clear();
            try
            {
                string hongKongDollar = await GetHongKongDollarValue();
                Console.WriteLine("Курс RUB к HKD:");
                Console.WriteLine(hongKongDollar);
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
            }
            Console.ReadLine();
        }

        static void Main(string[] args)
        {
            RunAsync().GetAwaiter().GetResult();
        }

        
    }
}
