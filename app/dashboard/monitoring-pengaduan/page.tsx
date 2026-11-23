
"use client";

import { useState } from "react";

type Pengaduan = {
  id: number;
  nama: string;
  kategori: string;
  tanggal: string;
  lokasi: string;
  status: string;
  keluhan: string;
};

export default function MonitoringPengaduan() {
  const [data, setData] = useState<Pengaduan[]>([
    {
      id: 1,
      nama: "Andi Saputra",
      kategori: "Gangguan Jaringan",
      tanggal: "23 November 2026",
      lokasi: "Pasarkemis",
      status: "Menunggu",
      keluhan: "Koneksi jaringan mengalami gangguan."
    },
    {
      id: 2,
      nama: "Budi Santoso",
      kategori: "Pelayanan",
      tanggal: "22 November 2026",
      lokasi: "Tangerang",
      status: "Diproses",
      keluhan: "Memerlukan tindak lanjut dari petugas."
    },
    {
      id: 3,
      nama: "Dedi Kurniawan",
      kategori: "Pemasangan",
      tanggal: "21 November 2026",
      lokasi: "Rajeg",
      status: "Selesai",
      keluhan: "Permintaan pemasangan sudah ditangani."
    }
  ]);

  const [cari, setCari] = useState("");
  const [filter, setFilter] = useState("Semua");
  const [pilihan, setPilihan] = useState<Pengaduan | null>(null);

  const hasil = data.filter((item) => {
    const cocokCari =
      item.nama.toLowerCase().includes(cari.toLowerCase()) ||
      item.kategori.toLowerCase().includes(cari.toLowerCase());

    const cocokStatus =
      filter === "Semua" || item.status === filter;

    return cocokCari && cocokStatus;
  });

  function ubahStatus(id: number, status: string) {
    setData((sebelumnya) =>
      sebelumnya.map((item) =>
        item.id === id ? { ...item, status } : item
      )
    );

    setPilihan(null);
  }

  const jumlah = (status: string) =>
    data.filter((item) => item.status === status).length;

  return (
    <main className="min-h-screen bg-[#f2f7ff] p-5 sm:p-8">
      <div className="mb-7">
        <p className="text-sm text-blue-600">
          Kepala SITE / Monitoring
        </p>

        <h1 className="mt-2 text-3xl font-bold text-[#0b3069]">
          Monitoring Pengaduan
        </h1>

        <p className="mt-2 text-sm text-slate-500">
          Pantau dan periksa pengaduan pelanggan.
        </p>
      </div>

      <section className="mb-6 grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-4">
        {[
          ["Total Pengaduan", data.length],
          ["Menunggu", jumlah("Menunggu")],
          ["Sedang Diproses", jumlah("Diproses")],
          ["Selesai", jumlah("Selesai")]
        ].map(([judul, angka]) => (
          <div
            key={judul}
            className="rounded-2xl border border-blue-100 bg-white p-5 shadow-sm"
          >
            <p className="text-sm text-slate-500">{judul}</p>
            <h2 className="mt-2 text-3xl font-bold text-[#0b3069]">
              {angka}
            </h2>
          </div>
        ))}
      </section>

      <section className="rounded-2xl border border-blue-100 bg-white p-5 shadow-sm">
        <div className="mb-5">
          <h2 className="text-xl font-bold text-[#0b3069]">
            Daftar Pengaduan Pelanggan
          </h2>

          <p className="mt-1 text-sm text-slate-500">
            Pilih pengaduan untuk melihat detailnya.
          </p>
        </div>

        <div className="mb-5 flex flex-col gap-3 sm:flex-row">
          <input
            value={cari}
            onChange={(e) => setCari(e.target.value)}
            placeholder="Cari nama atau kategori..."
            className="w-full rounded-xl border border-blue-100 px-4 py-3 outline-none focus:border-blue-500"
          />

          <select
            value={filter}
            onChange={(e) => setFilter(e.target.value)}
            className="rounded-xl border border-blue-100 px-4 py-3 outline-none"
          >
            <option>Semua</option>
            <option>Menunggu</option>
            <option>Diproses</option>
            <option>Selesai</option>
          </select>
        </div>

        <div className="overflow-x-auto">
          <table className="w-full min-w-[650px] text-left text-sm">
            <thead className="bg-blue-50 text-[#0b3069]">
              <tr>
                <th className="p-3">Pelanggan</th>
                <th className="p-3">Kategori</th>
                <th className="p-3">Tanggal</th>
                <th className="p-3">Status</th>
                <th className="p-3">Aksi</th>
              </tr>
            </thead>

            <tbody>
              {hasil.map((item) => (
                <tr key={item.id} className="border-b border-slate-100">
                  <td className="p-3 font-semibold">{item.nama}</td>
                  <td className="p-3">{item.kategori}</td>
                  <td className="p-3">{item.tanggal}</td>

                  <td className="p-3">
                    <span
                      className={`rounded-full px-3 py-1 text-xs font-semibold ${
                        item.status === "Selesai"
                          ? "bg-green-100 text-green-700"
                          : item.status === "Diproses"
                          ? "bg-blue-100 text-blue-700"
                          : "bg-yellow-100 text-yellow-700"
                      }`}
                    >
                      {item.status}
                    </span>
                  </td>

                  <td className="p-3">
                    <button
                      onClick={() => setPilihan(item)}
                      className="rounded-lg bg-[#0b3476] px-3 py-2 text-white hover:bg-blue-800"
                    >
                      Detail
                    </button>
                  </td>
                </tr>
              ))}

              {hasil.length === 0 && (
                <tr>
                  <td colSpan={5} className="p-6 text-center text-slate-500">
                    Pengaduan tidak ditemukan.
                  </td>
                </tr>
              )}
            </tbody>
          </table>
        </div>
      </section>

      {pilihan && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/40 p-4">
          <div className="w-full max-w-lg rounded-2xl bg-white p-6 shadow-xl">
            <div className="mb-5 flex items-center justify-between">
              <h2 className="text-xl font-bold text-[#0b3069]">
                Detail Pengaduan
              </h2>

              <button
                onClick={() => setPilihan(null)}
                className="text-xl text-slate-500"
              >
                ✕
              </button>
            </div>

            <div className="space-y-3 text-sm">
              <p><b>Nama:</b> {pilihan.nama}</p>
              <p><b>Kategori:</b> {pilihan.kategori}</p>
              <p><b>Tanggal:</b> {pilihan.tanggal}</p>
              <p><b>Lokasi:</b> {pilihan.lokasi}</p>
              <p><b>Status:</b> {pilihan.status}</p>

              <div className="rounded-xl bg-blue-50 p-4">
                <b>Isi Pengaduan</b>
                <p className="mt-2">{pilihan.keluhan}</p>
              </div>
            </div>

            <div className="mt-6 flex flex-wrap gap-2">
              <button
                onClick={() => ubahStatus(pilihan.id, "Diproses")}
                className="rounded-lg bg-blue-700 px-4 py-2 text-sm text-white"
              >
                Proses
              </button>

              <button
                onClick={() => ubahStatus(pilihan.id, "Selesai")}
                className="rounded-lg bg-green-600 px-4 py-2 text-sm text-white"
              >
                Tandai Selesai
              </button>

              <button
                onClick={() => setPilihan(null)}
                className="rounded-lg border px-4 py-2 text-sm"
              >
                Tutup
              </button>
            </div>
          </div>
        </div>
      )}
    </main>
  );
}
