
const puppeteer = require('puppeteer');
const fs = require('fs');
const data = fs.readFileSync('configuration-data.json');
var server = JSON.parse(data);


(async () => {
const browser = await puppeteer.launch({ headless: false, defaultViewport: { width: 1920, height: 1080 }, args: ['--start-maximized'] });
const page = await browser.newPage();
let element, formElement, tabs;


//inicio en pagina de instalacion
await page.goto('http://'+server.ip+':'+server.port+'/install/', { waitUntil: 'networkidle0' });
element = await page.$x(`//*[@id="btNext"]`);
	await element[0].click();
	await page.waitForNavigation();
    await page.content();
	console.log('Lenguaje de instalación => ENGLISH (ENGLISH)');	

//aceptación de licencia
element = await page.$x(`//*[@id="set_license"]`);
	await element[0].click();
element = await page.$x(`//*[@id="btNext"]`);
	await element[0].click();
	console.log('Licencia aceptada => SI');

//página siguiente
await page.waitForNavigation();
await page.content();

//datos de instalación página 1
element = await page.$x(`//*[@id="infosShop"]`);
	await element[0].click();
element = await page.$x(`//*[@id="infosShop"]`);
	await element[0].type(server.demoname);
	console.log('Nombre de instalación => '+server.demoname);

element = await page.$x(`//div[@id='infosActivity_chosen']/a/span`);
	await element[0].click();
element = await page.$x(`//div[@id='infosActivity_chosen']/div/div/input`);
	await element[0].type(server.shoppurpose);
element = await page.$x(`//div[@id='infosActivity_chosen']/div/ul/li`);
	await element[0].click();
	console.log('Tema de la tienda => Food and Beverage');

element = await page.$x(`//div[@id='infosShopBlock']/div[3]/div/label[2]/input`);
	await element[0].click();
	console.log('Data de prueba => NO)');

element = await page.$x(`//div[@id='infosCountry_chosen']/a/span`);
	await element[0].click();
element = await page.$x(`//div[@id='infosCountry_chosen']/div/div/input`);
	await element[0].type(`phi`);
element = await page.$x(`//div[@id='infosCountry_chosen']/div/ul/li`);
	await element[0].click();
	console.log('País por defecto => Philippines');

element = await page.$x(`//div[@id='infosShopBlock']/div[6]/div/label[2]/input`);
	await element[0].click();
element = await page.$x(`//*[@id="infosFirstname"]`);
	await element[0].click();
element = await page.$x(`//*[@id="infosFirstname"]`);
	await element[0].type(server.firstname);
	console.log('Nombre del administrador => '+server.firstname);

element = await page.$x(`//*[@id="infosName"]`);
	await element[0].click();
element = await page.$x(`//*[@id="infosName"]`);
	await element[0].type(server.surname);
	console.log('apellido del administrador => '+server.surname);

element = await page.$x(`//*[@id="infosEmail"]`);
	await element[0].click();
element = await page.$x(`//*[@id="infosEmail"]`);
	await element[0].type(server.email);
	console.log('Email - Usuario del administrador => '+server.email);

element = await page.$x(`//*[@id="infosPassword"]`);
	await element[0].click();
element = await page.$x(`//*[@id="infosPassword"]`);
	await element[0].type(server.password);
	console.log('Password => '+server.password);

element = await page.$x(`//*[@id="infosPasswordRepeat"]`);
	await element[0].click();
element = await page.$x(`//*[@id="infosPasswordRepeat"]`);
	await element[0].type(server.password);
	console.log('Confirmación de Password => '+server.password);

element = await page.$x(`//*[@id="btNext"]`);
	await element[0].click();
	console.log('Siguiente página => OK');

//datos de instalación página 2
await page.waitForNavigation();
await page.content();
element = await page.$x(`//div[@id='formCheckSQL']/p`);
	await element[0].click();
element = await page.$x(`//*[@id="dbServer"]`);
	await element[0].evaluate( element => element.value = "");
	await element[0].type(server.ip);
	console.log('Dirección de Base de Datos => '+server.ipdb);

element = await page.$x(`//*[@id="dbPassword"]`);
	await element[0].click();
element = await page.$x(`//*[@id="dbPassword"]`);
	await element[0].type(server.dbpassword);
	console.log('Password de base de datos => '+server.dbpassword);

element = await page.$x(`//*[@id="db_prefix"]`);
	await element[0].click();
	console.log('Prefijo de base de datos => default)');
element = await page.$x(`//*[@id="btTestDB"]`);
	await element[0].click();
	console.log('Prueba de conexión => OK');

element = await page.$x(`//*[@id="dbName"]`);
	await element[0].click();
element = await page.$x(`//*[@id="dbLogin"]`);
	await element[0].click();
element = await page.$x(`//*[@id="dbPassword"]`);
	await element[0].click();
element = await page.$x(`//*[@id="btNext"]`);
	await element[0].click();
	console.log('ESPERE MIENTRAS SE COMPLETA LA INSTALACIÓN');
//element = await page.$x(`//div[@id='boBlock']/p[2]/a/span`);
//	await element[0].click();

await page.waitForNavigation();
await page.content();
await page.waitForXPath('//*[@id="boBlock"]/p[2]/a/span', {visible: true, timeout: 9999999 })
	.then(()=>console.log("PROCEDA A BORRAR EL DIRECTORIO DE INTALACIÓN"));
element = await page.$x('//*[@id="boBlock"]/p[2]/a/span');
	await element[0].click();
await page.content();
await browser.close();
})();
