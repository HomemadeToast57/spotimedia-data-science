import React, { useState, useEffect } from 'react';
import { Bar } from 'react-chartjs-2';
import { Chart, CategoryScale, LinearScale, BarElement } from 'chart.js';

Chart.register(CategoryScale, LinearScale, BarElement);

const Youtube = () => {
    const [chartData, setChartData] = useState(null);

    useEffect(() => {
        fetch('http://localhost:1234/youtubeDailyCounts')
            .then(response => response.json())
            .then(({ labels, data }) => {
                setChartData({
                    labels: labels,
                    datasets: [{
                        label: 'Number of Youtube Posts per Query Block',
                        data: data,
                        backgroundColor: 'red',
                        borderColor: 'red',
                        borderWidth: 1
                    }]
                });
            })
            .catch(error => {
                console.error('Error fetching data:', error);
            });
    }, []);

    const options = {
        scales: {
            y: {
                beginAtZero: true
            }
        },
        responsive: true,
        maintainAspectRatio: false
    };

    return (
        <div>
            {chartData ? <Bar data={chartData} options={{ 
                maintainAspectRatio: false,
            }}
            style={{ width: '100%', height: '100%' }} /> : <p>Loading...</p>}
        </div>
    );
};

export default Youtube;