const express = require('express');
const cors = require('cors');
require('dotenv').config();


const app = express();

app.use(cors());
app.use(express.json());

const PORT = 3000;

const API_KEY = process.env.COINGECKO_API_KEY;

const BASE_URL = 'https://api.coingecko.com/api/v3';


// Get coins
app.get('/api/coins', async (req, res) => {
    try {
        const response = await fetch(
            `${BASE_URL}/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=50&page=1&sparkline=false&x_cg_demo_api_key=${API_KEY}`
        );

        if (!response.ok) {
            throw new Error('CoinGecko API error');
        }

        const data = await response.json();

        res.json(data);

    } catch (error) {
        console.log(error);

        res.status(500).json({
            message: 'Failed to get coins',
        });
    }
});


// Get chart data
app.get('/api/coins/:id/chart', async (req, res) => {
    try {
        const coinId = req.params.id;

        const response = await fetch(
            `${BASE_URL}/coins/${coinId}/market_chart?vs_currency=usd&days=7&x_cg_demo_api_key=${API_KEY}`
        );

        if (!response.ok) {
            throw new Error('CoinGecko chart API error');
        }

        const data = await response.json();

        res.json(data);

    } catch (error) {
        console.log(error);

        res.status(500).json({
            message: 'Failed to get chart data',
        });
    }
});


app.get('/', (req, res) => {
    res.send('CoinTracker Backend is running');
});


app.listen(PORT, () => {
    console.log(`Server running on http://localhost:${PORT}`);
});