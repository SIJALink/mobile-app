
"use client";

import { useState } from "react";

type Jadwal = {
  id: number;
  nama: string;
  tanggal: string;
  mulai: string;
  selesai: string;
  shift: string;
  lokasi: string;
  status: string;
};

const dataAwal: Jadwal[] = [
  {
    id: 1,
    nama: "Andi Saputra",
    tanggal: "2026-11-20",
    mulai: "08:00",
    selesai: "16:00",
    shift: "Pagi",
    lokasi: "SITE Utama",
    status: "Terjadwal",
  },
  {
    id: 2,
    nama: "Budi Santoso",
    tanggal: "2026-11-20",
    mulai: "16:00",
    selesai: "00:00",
    shift: "Sore",
    lokasi: "SITE Utama",
    status: "Terjadwal",
  },
  {
    id: 3,
    nama: "Dedi Kurniawan",
    tanggal: "2026-11-21",
    mulai: "08:00",
    selesai: "16:00",
    shift: "Pagi",
    lokasi: "Area Pelanggan",
    status: "Terjadwal",
  },
  {
    id: 4,
    nama: "Rizky Pratama",
    tanggal: "2026-11-21",
    mulai: "00:00",
    selesai: "08:00",
    shift: "Malam",
    lokasi: "SITE Utama",
    status: "Terjadwal",
  },
];

export default function JadwalPiket() {
  const [data, setData] = useState<Jadwal[]>(dataAwal);
  const [cari, setCari] = useState("");
  const [modal, setModal] = useState(false);
  const [editId, setEditId] = useState<number | null>(null);

  const [nama, setNama] = useState("");
  const [tanggal, setTanggal] = useState("");
  const [mulai, setMulai] = useState("08:00");
  const [selesai, setSelesai] = useState("16:00");
  const [shift, setShift] = useState("Pagi");
  const [lokasi, setLokasi] = useState("");
  const [status, setStatus] = useState("Terjadwal");

  const hasil = data.filter((item) =>
    item.nama.toLowerCase().includes(cari.toLowerCase()) ||
    item.lokasi.toLowerCase().includes(cari.toLowerCase())
  );

  const total = data.length;
  const pagi = data.filter((item) => item.shift === "Pagi").length;
  const sore = data.filter((item) => item.shift === "Sore").length;
  const malam = data.filter((item) => item.shift === "Malam").length;

  function resetForm() {
    setEditId(null);
    setNama("");
    setTanggal("");
    setMulai("08:00");
    setSelesai("16:00");
    setShift("Pagi");
    setLokasi("");
    setStatus("Terjadwal");
  }

  function bukaTambah() {
    resetForm();
    setModal(true);
  }

  function bukaEdit(item: Jadwal) {
    setEditId(item.id);
    setNama(item.nama);
    setTanggal(item.tanggal);
    setMulai(item.mulai);
    setSelesai(item.selesai);
    setShift(item.shift);
    setLokasi(item.lokasi);
    setStatus(item.status);
    setModal(true);
  }

  function simpan(e: React.FormEvent<HTMLFormElement>) {
    e.preventDefault();

    const jadwalBaru: Jadwal = {
      id: editId ?? Date.now(),
      nama,
      tanggal,
      mulai,
      selesai,
      shift,
      lokasi,
      status,
    };

    if (editId !== null) {
      setData((sebelumnya) =>
        sebelumnya.map((item) =>
          item.id === editId ? jadwalBaru : item
        )
      );
    } else {
      setData((sebelumnya) => [...sebelumnya, jadwalBaru]);
    }

    setModal(false);
    resetForm();
  }

  function hapus(id: number) {
    if (confirm("Yakin ingin menghapus jadwal ini?")) {
      setData((sebelumnya) =>
        sebelumnya.filter((item) => item.id !== id)
      );
    }
  }

  function formatTanggal(value: string) {
    if (!value) return "-";

    return new Date(value + "T00:00:00").toLocaleDateString(
      "id-ID",
      {
        day: "numeric",
        month: "long",
        year: "numeric",
      }
    );
  }

  return (
    <main className="min-h-screen bg-[#f1f6ff] p-4 text-[#102d60] sm:p-6 lg:p-8">
      <div className="mx-auto max-w-7xl">

        {/* HEADER */}
        <div className="mb-7 flex flex-wrap items-center justify-between gap-4">
          <div>
            <h1 className="text-2xl font-bold text-[#0c326b] sm:text-3xl">
              Jadwal Piket
            </h1>
            <p className="mt-1 text-sm text-gray-500">
              Kelola jadwal kerja dan pembagian shift petugas SIJALink.
            </p>
          </div>

          <button
            onClick={bukaTambah}
            className="rounded-xl bg-blue-700 px-5 py-3 text-sm font-semibold text-white shadow-sm hover:bg-blue-800"
          >
            + Tambah Jadwal
          </button>
        </div>

        {/* RINGKASAN */}
        <section className="mb-6 grid grid-cols-1 gap-4 sm:grid-cols-2 xl:grid-cols-4">
          {[
            {
              judul: "Total Jadwal",
              jumlah: total,
              warna: "text-blue-700",
              ikon: "▦",
            },
            {
              judul: "Shift Pagi",
              jumlah: pagi,
              warna: "text-green-600",
              ikon: "☀",
            },
            {
              judul: "Shift Sore",
              jumlah: sore,
              warna: "text-orange-500",
              ikon: "◷",
            },
            {
              judul: "Shift Malam",
              jumlah: malam,
              warna: "text-purple-600",
              ikon: "☾",
            },
          ].map((item) => (
            <div
              key={item.judul}
              className="flex items-center gap-4 rounded-2xl border border-blue-100 bg-white p-5 shadow-sm"
            >
              <div className="flex h-14 w-14 items-center justify-center rounded-full bg-blue-50 text-2xl text-blue-700">
                {item.ikon}
              </div>

              <div>
                <p className="text-sm text-gray-500">{item.judul}</p>
                <h2 className={`mt-1 text-3xl font-bold ${item.warna}`}>
                  {item.jumlah}
                </h2>
              </div>
            </div>
          ))}
        </section>

        {/* DAFTAR JADWAL */}
        <section className="rounded-2xl border border-blue-100 bg-white p-5 shadow-sm sm:p-6">
          <div className="mb-5">
            <h2 className="text-lg font-bold text-[#0c326b]">
              Daftar Jadwal Petugas
            </h2>
            <p className="text-sm text-gray-500">
              Informasi pembagian jadwal dan shift petugas.
            </p>
          </div>

          <input
            value={cari}
            onChange={(e) => setCari(e.target.value)}
            placeholder="Cari nama petugas atau lokasi..."
            className="mb-5 w-full rounded-xl border border-gray-300 px-4 py-3 text-sm text-gray-800 outline-none focus:border-blue-600 md:max-w-sm"
          />

          <div className="overflow-x-auto">
            <table className="w-full min-w-[850px] text-left text-sm">
              <thead className="bg-blue-50 text-[#0c326b]">
                <tr>
                  <th className="p-4">No</th>
                  <th className="p-4">Nama Petugas</th>
                  <th className="p-4">Tanggal</th>
                  <th className="p-4">Jam Piket</th>
                  <th className="p-4">Shift</th>
                  <th className="p-4">Lokasi</th>
                  <th className="p-4">Status</th>
                  <th className="p-4">Aksi</th>
                </tr>
              </thead>

              <tbody>
                {hasil.map((item, index) => (
                  <tr
                    key={item.id}
                    className="border-b border-gray-100 hover:bg-blue-50"
                  >
                    <td className="p-4 text-gray-600">{index + 1}</td>

                    <td className="p-4 font-semibold text-gray-800">
                      {item.nama}
                    </td>

                    <td className="p-4 text-gray-600">
                      {formatTanggal(item.tanggal)}
                    </td>

                    <td className="p-4 text-gray-600">
                      {item.mulai} - {item.selesai}
                    </td>

                    <td className="p-4">
                      <span className="rounded-full bg-blue-100 px-3 py-1 text-xs font-semibold text-blue-700">
                        {item.shift}
                      </span>
                    </td>

                    <td className="p-4 text-gray-600">
                      {item.lokasi}
                    </td>

                    <td className="p-4">
                      <span className="rounded-full bg-green-100 px-3 py-1 text-xs font-semibold text-green-700">
                        {item.status}
                      </span>
                    </td>

                    <td className="p-4">
                      <div className="flex gap-2">
                        <button
                          onClick={() => bukaEdit(item)}
                          className="rounded-lg bg-yellow-100 px-3 py-2 text-xs font-semibold text-yellow-700 hover:bg-yellow-200"
                        >
                          Edit
                        </button>

                        <button
                          onClick={() => hapus(item.id)}
                          className="rounded-lg bg-red-100 px-3 py-2 text-xs font-semibold text-red-600 hover:bg-red-200"
                        >
                          Hapus
                        </button>
                      </div>
                    </td>
                  </tr>
                ))}

                {hasil.length === 0 && (
                  <tr>
                    <td
                      colSpan={8}
                      className="p-8 text-center text-gray-500"
                    >
                      Jadwal tidak ditemukan.
                    </td>
                  </tr>
                )}
              </tbody>
            </table>
          </div>
        </section>

        {/* MODAL TAMBAH DAN EDIT */}
        {modal && (
          <div className="fixed inset-0 z-50 flex items-center justify-center overflow-y-auto bg-black/50 p-4">
            <form
              onSubmit={simpan}
              className="my-5 w-full max-w-lg rounded-2xl bg-white p-6 shadow-xl"
            >
              <h2 className="mb-5 text-xl font-bold text-[#0c326b]">
                {editId !== null ? "Edit Jadwal Piket" : "Tambah Jadwal Piket"}
              </h2>

              <div className="space-y-4">
                <div>
                  <label className="mb-2 block text-sm font-medium text-gray-700">
                    Nama Petugas
                  </label>
                  <input
                    required
                    value={nama}
                    onChange={(e) => setNama(e.target.value)}
                    placeholder="Masukkan nama petugas"
                    className="w-full rounded-lg border border-gray-300 p-3 text-gray-800 outline-none focus:border-blue-600"
                  />
                </div>

                <div>
                  <label className="mb-2 block text-sm font-medium text-gray-700">
                    Tanggal Piket
                  </label>
                  <input
                    required
                    type="date"
                    value={tanggal}
                    onChange={(e) => setTanggal(e.target.value)}
                    className="w-full rounded-lg border border-gray-300 p-3 text-gray-800"
                  />
                </div>

                <div className="grid grid-cols-2 gap-3">
                  <div>
                    <label className="mb-2 block text-sm font-medium text-gray-700">
                      Jam Mulai
                    </label>
                    <input
                      required
                      type="time"
                      value={mulai}
                      onChange={(e) => setMulai(e.target.value)}
                      className="w-full rounded-lg border border-gray-300 p-3 text-gray-800"
                    />
                  </div>

                  <div>
                    <label className="mb-2 block text-sm font-medium text-gray-700">
                      Jam Selesai
                    </label>
                    <input
                      required
                      type="time"
                      value={selesai}
                      onChange={(e) => setSelesai(e.target.value)}
                      className="w-full rounded-lg border border-gray-300 p-3 text-gray-800"
                    />
                  </div>
                </div>

                <div>
                  <label className="mb-2 block text-sm font-medium text-gray-700">
                    Shift
                  </label>
                  <select
                    value={shift}
                    onChange={(e) => setShift(e.target.value)}
                    className="w-full rounded-lg border border-gray-300 p-3 text-gray-800"
                  >
                    <option>Pagi</option>
                    <option>Sore</option>
                    <option>Malam</option>
                  </select>
                </div>

                <div>
                  <label className="mb-2 block text-sm font-medium text-gray-700">
                    Lokasi Piket
                  </label>
                  <input
                    required
                    value={lokasi}
                    onChange={(e) => setLokasi(e.target.value)}
                    placeholder="Contoh: SITE Utama"
                    className="w-full rounded-lg border border-gray-300 p-3 text-gray-800"
                  />
                </div>

                <div>
                  <label className="mb-2 block text-sm font-medium text-gray-700">
                    Status
                  </label>
                  <select
                    value={status}
                    onChange={(e) => setStatus(e.target.value)}
                    className="w-full rounded-lg border border-gray-300 p-3 text-gray-800"
                  >
                    <option>Terjadwal</option>
                    <option>Selesai</option>
                    <option>Dibatalkan</option>
                  </select>
                </div>
              </div>

              <div className="mt-6 flex justify-end gap-3">
                <button
                  type="button"
                  onClick={() => {
                    setModal(false);
                    resetForm();
                  }}
                  className="rounded-lg bg-gray-200 px-4 py-2 text-sm font-semibold text-gray-700 hover:bg-gray-300"
                >
                  Batal
                </button>

                <button
                  type="submit"
                  className="rounded-lg bg-blue-700 px-5 py-2 text-sm font-semibold text-white hover:bg-blue-800"
                >
                  Simpan
                </button>
              </div>
            </form>
          </div>
        )}
      </div>
    </main>
  );
}
