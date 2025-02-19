import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="chart"
export default class extends Controller {
  connect() {
    this.buildChart()
  }

  buildChart() {
    buildChart('#hs-multiple-area-charts', (mode) => ({
      chart: {
        height: 300,
        type: 'area',
        toolbar: {
          show: false
        },
        zoom: {
          enabled: false
        }
      },
      series: [
        {
          name: 'Income',
          data: [20000, 30000, 40000, 50000, 60000, 70000, 80000, 90000, 100000, 110000, 120000, 130000]
        },
        {
          name: 'Outcome',
          data: [15000, 20000, 25000, 30000, 35000, 40000, 45000, 50000, 55000, 60000, 65000, 70000]
        }
      ],
      legend: {
        show: false
      },
      dataLabels: {
        enabled: false
      },
      stroke: {
        curve: 'straight',
        width: 2
      },
      grid: {
        strokeDashArray: 2
      },
      fill: {
        type: 'gradient',
        gradient: {
          type: 'vertical',
          shadeIntensity: 1,
          opacityFrom: 0.1,
          opacityTo: 0.8
        }
      },
      xaxis: {
        type: 'category',
        tickPlacement: 'on',
        categories: [
          'January 2023',
          'February 2023',
          'March 2023',
          'April 2023',
          'May 2023',
          'June 2023',
          'July 2023',
          'August 2023',
          'September 2023',
          'October 2023',
          'November 2023',
          'December 2023'
        ],
        axisBorder: {
          show: false
        },
        axisTicks: {
          show: false
        },
        crosshairs: {
          stroke: {
            dashArray: 0
          },
          dropShadow: {
            show: false
          }
        },
        tooltip: {
          enabled: false
        },
        labels: {
          style: {
            colors: '#9ca3af',
            fontSize: '13px',
            fontFamily: 'Inter, ui-sans-serif',
            fontWeight: 400
          },
          formatter: (title) => {
            let t = title;

            if (t) {
              const newT = t.split(' ');
              t = `${newT[0]} ${newT[1].slice(0, 3)}`;
            }

            return t;
          }
        }
      },
      yaxis: {
        labels: {
          align: 'left',
          minWidth: 0,
          maxWidth: 140,
          style: {
            colors: '#9ca3af',
            fontSize: '13px',
            fontFamily: 'Inter, ui-sans-serif',
            fontWeight: 400
          },
          formatter: (value) => value >= 1000 ? `${value / 1000}k` : value
        }
      },
      tooltip: {
        x: {
          format: 'MMMM yyyy'
        },
        y: {
          formatter: (value) => `$${value >= 1000 ? `${value / 1000}k` : value}`
        },
        custom: function (props) {
          const { categories } = props.ctx.opts.xaxis;
          const { dataPointIndex } = props;
          const title = categories[dataPointIndex].split(' ');
          const newTitle = `${title[0]} ${title[1]}`;

          return buildTooltip(props, {
            title: newTitle,
            mode,
            hasTextLabel: true,
            wrapperExtClasses: 'min-w-28',
            labelDivider: ':',
            labelExtClasses: 'ms-2'
          });
        }
      },
      responsive: [{
        breakpoint: 568,
        options: {
          chart: {
            height: 300
          },
          labels: {
            style: {
              colors: '#9ca3af',
              fontSize: '11px',
              fontFamily: 'Inter, ui-sans-serif',
              fontWeight: 400
            },
            offsetX: -2,
            formatter: (title) => title.slice(0, 3)
          },
          yaxis: {
            labels: {
              align: 'left',
              minWidth: 0,
              maxWidth: 140,
              style: {
                colors: '#9ca3af',
                fontSize: '11px',
                fontFamily: 'Inter, ui-sans-serif',
                fontWeight: 400
              },
              formatter: (value) => value >= 1000 ? `${value / 1000}k` : value
            }
          },
        },
      }]
    }), {
      colors: ['#2563eb', '#9333ea'],
      fill: {
        gradient: {
          stops: [0, 90, 100]
        }
      },
      xaxis: {
        labels: {
          style: {
            colors: '#9ca3af'
          }
        }
      },
      yaxis: {
        labels: {
          style: {
            colors: '#9ca3af'
          }
        }
      },
      grid: {
        borderColor: '#e5e7eb'
      }
    }, {
      colors: ['#3b82f6', '#a855f7'],
      fill: {
        gradient: {
          stops: [100, 90, 0]
        }
      },
      xaxis: {
        labels: {
          style: {
            colors: '#a3a3a3',
          }
        }
      },
      yaxis: {
        labels: {
          style: {
            colors: '#a3a3a3'
          }
        }
      },
      grid: {
        borderColor: '#404040'
      }
    });
  }
}
