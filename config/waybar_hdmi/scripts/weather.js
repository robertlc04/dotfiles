#!/usr/bin/env bun

// Constant Vars
const WEATHER_CODES = {
    '113': '☀️ ',
    '116': '⛅ ',
    '119': '☁️ ',
    '122': '☁️ ',
    '143': '☁️ ',
    '176': '🌧️',
    '179': '🌧️',
    '182': '🌧️',
    '185': '🌧️',
    '200': '⛈️ ',
    '227': '🌨️',
    '230': '🌨️',
    '248': '☁️ ',
    '260': '☁️ ',
    '263': '🌧️',
    '266': '🌧️',
    '281': '🌧️',
    '284': '🌧️',
    '293': '🌧️',
    '296': '🌧️',
    '299': '🌧️',
    '302': '🌧️',
    '305': '🌧️',
    '308': '🌧️',
    '311': '🌧️',
    '314': '🌧️',
    '317': '🌧️',
    '320': '🌨️',
    '323': '🌨️',
    '326': '🌨️',
    '329': '❄️ ',
    '332': '❄️ ',
    '335': '❄️ ',
    '338': '❄️ ',
    '350': '🌧️',
    '353': '🌧️',
    '356': '🌧️',
    '359': '🌧️',
    '362': '🌧️',
    '365': '🌧️',
    '368': '🌧️',
    '371': '❄️',
    '374': '🌨️',
    '377': '🌨️',
    '386': '🌨️',
    '389': '🌨️',
    '392': '🌧️',
    '395': '❄️ '
}

const getlocation = async () => {
  return await fetch("http://ipwho.is/").then( (resp) => {
    return resp.json()
  }).then( data => {
    const { latitude,longitude } = data
    return { "lat":latitude, "lon":longitude }
  }).catch( err => {
    return err;
  })
}

const getweather = async (lat, lon) => {
  const headers = {
    method: 'GET',
    headers: {
      'X-RapidAPI-Key': 'bc41139669msh31e339df368d583p16878cjsn4c9fbd1c43f6',
      'X-RapidAPI-Host': 'weatherapi-com.p.rapidapi.com'
    }
  };

  return await fetch(`https://weatherapi-com.p.rapidapi.com/current.json?q=${lat}%2C${lon}`,headers).then(
    resp => resp.json() 
  ).then( data => {
    return data
  }).catch( err => {
    return err
  })

}

const format = (w,icon) => {
  const formated = {}
  formated['text'] = `${WEATHER_CODES[`${icon}`]} ${w.current.temp_c}°`
  formated['tooltip'] = 
    `${w.current.condition.text} ${w.current.temp_c}°
Feels Like C°: ${w.current.feelslike_c} 
Winds: ${w.current.wind_kph}
Humidity: ${w.current.humidity}
`
    return JSON.stringify(formated)
}

try {
  const coords = await getlocation();
  if (Object.getPrototypeOf(coords).name === "Error") {
    throw coords
  }
  const weather = await getweather(coords.lat, coords.lon)
  if (Object.getPrototypeOf(weather).name === "Error") {
    throw coords
  }
  const rawIcon = weather.current.condition.icon
  const icon = rawIcon.substring(rawIcon.lastIndexOf('/') + 1).replaceAll('.png', '')

  console.log(format(weather,icon))
} catch(e) {
  const fErr = {}
  fErr['text'] = "💀"
  fErr['tooltip'] = `${e.message}`
  console.log(JSON.stringify(fErr))
}




//
// const openweather: any = fetch("")
//
// const resp: any = fetch("https://wttr.in/?format=j1").then((r) => {
//   r
// })


