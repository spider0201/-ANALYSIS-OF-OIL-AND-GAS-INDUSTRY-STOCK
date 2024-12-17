# Import thư viện
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.preprocessing import MinMaxScaler
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import LSTM, Dense

# Đọc dữ liệu
df = pd.read_excel('./clean_data/history_price.xlsx')
stock_name = 'TOS'
df = df[df['stock_name'] == stock_name][['date', 'close']].set_index('date')

# Chuẩn hóa dữ liệu
scaler = MinMaxScaler(feature_range=(0, 1))
scaled_data = scaler.fit_transform(df)

# Tạo tập dữ liệu để huấn luyện
time_step = 60
X, y = [], []
for i in range(time_step, len(scaled_data)):
    X.append(scaled_data[i-time_step:i, 0])
    y.append(scaled_data[i, 0])

X = np.array(X).reshape(-1, time_step, 1)
y = np.array(y)

# Khởi tạo và huấn luyện mô hình
model = Sequential([
    LSTM(50, return_sequences=True, input_shape=(time_step, 1)),
    LSTM(50, return_sequences=False),
    Dense(25),
    Dense(1)
])

model.compile(optimizer='adam', loss='mean_squared_error')
model.fit(X, y, batch_size=32, epochs=50, verbose=1)

# Số ngày cần dự báo
future_days = 10

# Lấy dữ liệu cuối cùng để khởi tạo dự báo
last_60_days = scaled_data[-time_step:]
predictions = []

for _ in range(future_days):
    # Dự báo giá ngày tiếp theo
    X_future = last_60_days.reshape(1, time_step, 1)
    next_price = model.predict(X_future)[0, 0]

    # Lưu kết quả
    predictions.append(next_price)

    # Cập nhật dữ liệu
    last_60_days = np.append(last_60_days[1:], next_price).reshape(-1, 1)

# Chuyển dự báo về giá trị gốc
predicted_prices = scaler.inverse_transform(np.array(predictions).reshape(-1, 1))

# Tạo DataFrame kết quả
future_dates = pd.date_range(start=df.index[-1], periods=future_days+1, freq='B')[1:]
forecast_df = pd.DataFrame({
    'Ngày': future_dates,
    'Giá dự báo': predicted_prices.flatten()
})
# Định dạng cột ngày
df.index = pd.to_datetime(df.index, errors='coerce')
forecast_df['Ngày'] = pd.to_datetime(forecast_df['Ngày'], errors='coerce')

# Hiển thị kết quả
plt.figure(figsize=(14, 7))
plt.plot(df.index, df['close'], label='Giá thực tế')
plt.plot(forecast_df['Ngày'], forecast_df['Giá dự báo'], label='Giá dự báo', linestyle='--')
plt.xlabel('Ngày')
plt.ylabel('Giá cổ phiếu')
plt.title(f'Dự báo giá cổ phiếu {stock_name} cho {future_days} ngày tiếp theo')
plt.legend()
plt.show()
#Xuất file kết quả
forecast_df.to_excel(f'forecast_{stock_name}.xlsx', index=False)
